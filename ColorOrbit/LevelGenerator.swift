//
//  LevelGenerator.swift
//  ColorOrbit
//

import Foundation

struct LevelGenerator {

    // MARK: - Difficulty Configuration

    static func colorCount(for level: Int) -> Int {
        switch level {
        case 1...5:     return 3
        case 6...7:     return 4
        case 8...10:    return 4
        case 11...15:   return 5
        case 16...22:   return 5
        case 23...30:   return 6
        case 31...45:   return 6
        case 46...60:   return 7
        case 61...80:   return 7
        default:        return 8
        }
    }

    static func tubeCapacity(for level: Int) -> Int {
        return level >= 61 ? 5 : 4
    }

    static func emptyTubeCount(for level: Int) -> Int {
        switch level {
        case 1...7:     return 2
        case 8...12:    return 2
        case 13...15:   return 1
        case 16...19:   return 2
        case 20...30:   return 1
        default:        return 1
        }
    }

    /// Target BFS min-move range (single-ball moves).
    static func targetRange(for level: Int) -> ClosedRange<Int> {
        let base: Int
        switch level {
        case 1:         base = 3
        case 2:         base = 5
        case 3:         base = 7
        case 4...5:     base = 10
        case 6...7:     base = 14
        case 8...10:    base = 18
        case 11...15:   base = 22
        case 16...22:   base = 26
        case 23...30:   base = 30
        default:        base = 34
        }
        let margin = max(base / 4, 3)
        return base...(base + margin)
    }

    /// Minimum disorder score — higher = more mixed starting position.
    private static func minDisorder(for level: Int, colors: Int) -> Int {
        let colorFactor = colors * (colors - 1)
        let levelBonus: Int
        switch level {
        case 1...7:     levelBonus = 0
        case 8...15:    levelBonus = 4
        case 16...30:   levelBonus = 8
        case 31...60:   levelBonus = 12
        case 61...150:  levelBonus = 16
        default:        levelBonus = 20
        }
        return colorFactor + levelBonus
    }

    // MARK: - Public Generation Entry Point

    static func generate(level: Int) -> (tubes: [[Ball]], targets: [BallColor?]) {
        let colors = colorCount(for: level)
        let capacity = tubeCapacity(for: level)
        let empties = emptyTubeCount(for: level)
        let availableColors = Array(BallColor.allCases.prefix(colors))
        let baseSeed = UInt64(level) &* 6364136223846793005 &+ 1442695040888963407

        let tubes: [[Ball]]

        // Levels 1-3: near-sorted tutorial puzzles
        if level <= 3 {
            let reverseMoves = level + 2  // 3, 4, 5 reverse moves
            tubes = generateNearSorted(
                colors: colors, capacity: capacity, empties: empties,
                availableColors: availableColors, seed: baseSeed,
                reverseMoves: reverseMoves
            )
        } else {
            // For ≤4 colors with manageable target depth: BFS to verify exact difficulty
            let range = targetRange(for: level)
            if colors <= 4 && range.upperBound <= 17 {
                if let result = generateWithBFS(
                    colors: colors, capacity: capacity, empties: empties,
                    availableColors: availableColors, baseSeed: baseSeed, range: range
                ) {
                    tubes = result
                } else {
                    tubes = generateRandom(
                        level: level, colors: colors, capacity: capacity, empties: empties,
                        availableColors: availableColors, baseSeed: baseSeed
                    )
                }
            } else {
                // 5+ colors: random placement + disorder/solvability checks
                tubes = generateRandom(
                    level: level, colors: colors, capacity: capacity, empties: empties,
                    availableColors: availableColors, baseSeed: baseSeed
                )
            }
        }

        // Generate target assignments
        let targets = generateTargets(
            availableColors: availableColors, empties: empties, seed: baseSeed
        )

        return (tubes, targets)
    }

    // MARK: - Target Generation

    private static func generateTargets(
        availableColors: [BallColor], empties: Int, seed: UInt64
    ) -> [BallColor?] {
        var rng = SeededRandomNumberGenerator(seed: seed &+ 9876543210)
        var shuffled = availableColors
        // Fisher-Yates shuffle for target assignment
        for i in stride(from: shuffled.count - 1, through: 1, by: -1) {
            let j = Int.random(in: 0...i, using: &rng)
            shuffled.swapAt(i, j)
        }
        var targets: [BallColor?] = shuffled.map { $0 }
        for _ in 0..<empties {
            targets.append(nil)
        }
        return targets
    }

    // MARK: - Near-Sorted Tutorial Generation (Levels 1-3)

    private static func generateNearSorted(
        colors: Int, capacity: Int, empties: Int,
        availableColors: [BallColor], seed: UInt64,
        reverseMoves: Int
    ) -> [[Ball]] {
        var rng = SeededRandomNumberGenerator(seed: seed)

        // Start with solved state
        var tubes: [[BallColor]] = availableColors.map { color in
            Array(repeating: color, count: capacity)
        }
        for _ in 0..<empties { tubes.append([]) }

        // Apply random reverse moves to create a near-sorted puzzle
        var applied = 0
        var attempts = 0
        while applied < reverseMoves && attempts < 200 {
            attempts += 1
            let src = Int.random(in: 0..<tubes.count, using: &rng)
            let dest = Int.random(in: 0..<tubes.count, using: &rng)
            guard src != dest,
                  !tubes[src].isEmpty,
                  tubes[dest].count < capacity else { continue }

            // Don't move from a tube that only has 1 ball left (too easy to reverse)
            if tubes[src].count <= 1 && applied > 1 { continue }

            let ball = tubes[src].removeLast()
            tubes[dest].append(ball)
            applied += 1
        }

        // Ensure we're not still solved
        if isSolvedColors(tubes, capacity: capacity) {
            // Force one more move
            for src in tubes.indices where !tubes[src].isEmpty {
                for dest in tubes.indices where dest != src && tubes[dest].count < capacity {
                    if !tubes[src].isEmpty && tubes[src].last != tubes[dest].last {
                        let ball = tubes[src].removeLast()
                        tubes[dest].append(ball)
                        break
                    }
                }
                if !isSolvedColors(tubes, capacity: capacity) { break }
            }
        }

        return tubes.map { $0.map { Ball(color: $0) } }
    }

    // MARK: - BFS-Verified Generation (≤4 colors)

    private static func generateWithBFS(
        colors: Int, capacity: Int, empties: Int,
        availableColors: [BallColor], baseSeed: UInt64, range: ClosedRange<Int>
    ) -> [[Ball]]? {
        let maxSearch = range.upperBound + 12

        for attempt: UInt64 in 0..<500 {
            var rng = SeededRandomNumberGenerator(seed: baseSeed &+ attempt &* 2654435761)

            let tubes = randomPlacement(
                availableColors: availableColors, capacity: capacity,
                empties: empties, rng: &rng
            )

            if isSolvedColors(tubes, capacity: capacity) { continue }

            // No tube should already be complete
            let hasCompletedTube = tubes.contains { tube in
                guard tube.count == capacity, let first = tube.first else { return false }
                return tube.allSatisfy { $0 == first }
            }
            if hasCompletedTube { continue }

            if countValidMoves(tubes, capacity: capacity) < 2 { continue }

            if let moves = bfsMinMoves(tubes, capacity: capacity, maxDepth: maxSearch, maxStates: 500_000) {
                if range.contains(moves) {
                    return tubes.map { $0.map { Ball(color: $0) } }
                }
            }
        }
        return nil
    }

    // MARK: - Random Placement Generation (5+ colors)

    private static func generateRandom(
        level: Int, colors: Int, capacity: Int, empties: Int,
        availableColors: [BallColor], baseSeed: UInt64
    ) -> [[Ball]] {
        let minDis = minDisorder(for: level, colors: colors)

        // Primary pass: full disorder + solvability
        for attempt: UInt64 in 0..<500 {
            var rng = SeededRandomNumberGenerator(seed: baseSeed &+ attempt &* 2654435761)

            let tubes = randomPlacement(
                availableColors: availableColors, capacity: capacity,
                empties: empties, rng: &rng
            )

            if isSolvedColors(tubes, capacity: capacity) { continue }

            let hasCompletedTube = tubes.contains { tube in
                guard tube.count == capacity, let first = tube.first else { return false }
                return tube.allSatisfy { $0 == first }
            }
            if hasCompletedTube { continue }

            if disorderScore(tubes) < minDis { continue }
            if countValidMoves(tubes, capacity: capacity) < 2 { continue }
            if !isSolvable(tubes, capacity: capacity) { continue }

            return tubes.map { $0.map { Ball(color: $0) } }
        }

        // Relaxed pass: lower disorder requirement
        for attempt: UInt64 in 500..<1000 {
            var rng = SeededRandomNumberGenerator(seed: baseSeed &+ attempt &* 2654435761)
            let tubes = randomPlacement(
                availableColors: availableColors, capacity: capacity,
                empties: empties, rng: &rng
            )
            if isSolvedColors(tubes, capacity: capacity) { continue }
            if countValidMoves(tubes, capacity: capacity) < 1 { continue }
            if isSolvable(tubes, capacity: capacity) {
                return tubes.map { $0.map { Ball(color: $0) } }
            }
        }

        // Extra empty tube fallback
        for attempt: UInt64 in 1000..<2000 {
            var rng = SeededRandomNumberGenerator(seed: baseSeed &+ attempt &* 2654435761)
            let tubes = randomPlacement(
                availableColors: availableColors, capacity: capacity,
                empties: max(empties, 2), rng: &rng
            )
            if isSolvedColors(tubes, capacity: capacity) { continue }
            if isSolvable(tubes, capacity: capacity) {
                return tubes.map { $0.map { Ball(color: $0) } }
            }
        }

        // Absolute last resort — trivial solvable puzzle
        var fallback: [[Ball]] = []
        for color in availableColors {
            fallback.append(Array(repeating: Ball(color: color), count: capacity))
        }
        for _ in 0..<max(empties, 2) { fallback.append([]) }
        return fallback
    }

    // MARK: - Fisher-Yates Random Placement

    private static func randomPlacement(
        availableColors: [BallColor], capacity: Int, empties: Int,
        rng: inout SeededRandomNumberGenerator
    ) -> [[BallColor]] {
        let colors = availableColors.count

        var allBalls: [BallColor] = []
        for color in availableColors {
            for _ in 0..<capacity { allBalls.append(color) }
        }

        // Fisher-Yates shuffle
        for i in stride(from: allBalls.count - 1, through: 1, by: -1) {
            let j = Int.random(in: 0...i, using: &rng)
            allBalls.swapAt(i, j)
        }

        // Distribute into tubes
        var tubes: [[BallColor]] = []
        var idx = 0
        for _ in 0..<colors {
            var tube: [BallColor] = []
            for _ in 0..<capacity {
                tube.append(allBalls[idx])
                idx += 1
            }
            tubes.append(tube)
        }
        for _ in 0..<empties { tubes.append([]) }

        return tubes
    }

    // MARK: - BFS Solver (single-ball moves)

    private static func bfsMinMoves(
        _ initial: [[BallColor]], capacity: Int, maxDepth: Int, maxStates: Int
    ) -> Int? {
        if isSolvedColors(initial, capacity: capacity) { return 0 }

        var queue: [([[BallColor]], Int)] = [(initial, 0)]
        var visited = Set<[UInt64]>()
        visited.insert(canonicalKey(initial))
        var head = 0

        while head < queue.count {
            let (current, depth) = queue[head]
            head += 1

            if depth >= maxDepth { continue }
            if visited.count >= maxStates { return nil }

            for src in current.indices where !current[src].isEmpty {
                let topColor = current[src].last!

                var triedEmptyDest = false
                for dest in current.indices where dest != src {
                    let d = current[dest]

                    if d.isEmpty {
                        if triedEmptyDest { continue }
                        triedEmptyDest = true
                    }

                    // Validate single-ball move
                    let canMove: Bool
                    if d.isEmpty {
                        canMove = true
                    } else if d.last == topColor && d.count < capacity {
                        canMove = true
                    } else {
                        canMove = false
                    }

                    guard canMove else { continue }

                    var next = current
                    next[src].removeLast()
                    next[dest].append(topColor)

                    if isSolvedColors(next, capacity: capacity) {
                        return depth + 1
                    }

                    let key = canonicalKey(next)
                    if !visited.contains(key) {
                        visited.insert(key)
                        queue.append((next, depth + 1))
                    }
                }
            }
        }
        return nil
    }

    // MARK: - DFS Solvability Check (5+ colors)

    private static func isSolvable(_ initial: [[BallColor]], capacity: Int, maxStates: Int = 300_000) -> Bool {
        if isSolvedColors(initial, capacity: capacity) { return true }

        var visited = Set<[UInt64]>()
        visited.insert(canonicalKey(initial))
        var stack: [[[BallColor]]] = [initial]

        while let current = stack.popLast() {
            if visited.count >= maxStates { return false }

            for src in current.indices where !current[src].isEmpty {
                let topColor = current[src].last!

                // Skip moving from a completed tube
                if current[src].count == capacity && current[src].allSatisfy({ $0 == topColor }) {
                    continue
                }

                var triedEmptyDest = false
                for dest in current.indices where dest != src {
                    let d = current[dest]

                    if d.isEmpty {
                        if triedEmptyDest { continue }
                        triedEmptyDest = true
                    }

                    let canMove: Bool
                    if d.isEmpty {
                        canMove = true
                    } else if d.last == topColor && d.count < capacity {
                        canMove = true
                    } else {
                        canMove = false
                    }

                    guard canMove else { continue }

                    // Don't move single ball to empty tube (pointless)
                    if current[src].count == 1 && d.isEmpty { continue }

                    var next = current
                    next[src].removeLast()
                    next[dest].append(topColor)

                    if isSolvedColors(next, capacity: capacity) { return true }

                    let key = canonicalKey(next)
                    if !visited.contains(key) {
                        visited.insert(key)
                        stack.append(next)
                    }
                }
            }
        }
        return false
    }

    // MARK: - Helpers

    private static func canonicalKey(_ tubes: [[BallColor]]) -> [UInt64] {
        tubes.map { tube -> UInt64 in
            var h: UInt64 = 0
            for (i, c) in tube.enumerated() {
                h |= UInt64(c.rawIndex) << (i * 4)
            }
            h |= UInt64(tube.count) << 60
            return h
        }.sorted()
    }

    private static func countValidMoves(_ tubes: [[BallColor]], capacity: Int) -> Int {
        var count = 0
        for src in tubes.indices where !tubes[src].isEmpty {
            let color = tubes[src].last!
            for dest in tubes.indices where dest != src {
                let d = tubes[dest]
                if d.isEmpty || (d.count < capacity && d.last == color) {
                    count += 1
                }
            }
        }
        return count
    }

    private static func disorderScore(_ tubes: [[BallColor]]) -> Int {
        var score = 0
        for tube in tubes where !tube.isEmpty {
            let unique = Set(tube)
            score += unique.count - 1
            for i in 1..<tube.count {
                if tube[i] != tube[i - 1] { score += 1 }
            }
        }
        return score
    }

    private static func isSolvedColors(_ tubes: [[BallColor]], capacity: Int) -> Bool {
        let filled = tubes.filter { !$0.isEmpty }
        return filled.allSatisfy { tube in
            guard let first = tube.first else { return true }
            return tube.allSatisfy { $0 == first } && tube.count == capacity
        }
    }
}
