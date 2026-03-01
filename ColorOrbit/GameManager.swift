//
//  GameManager.swift
//  ColorOrbit
//

import SwiftUI

@MainActor
class GameManager: ObservableObject {

    // MARK: - Published State

    @Published var currentLevel: Int {
        didSet { UserDefaults.standard.set(currentLevel, forKey: "co_currentLevel") }
    }
    @Published var tubes: [[Ball]] = []
    @Published var tubeTargets: [BallColor?] = []
    @Published var selectedTubeIndex: Int? = nil
    @Published var freeUndos: Int = 3
    @Published var adUndos: Int = 0
    @Published var purchasedUndos: Int {
        didSet { UserDefaults.standard.set(purchasedUndos, forKey: "co_purchasedUndos") }
    }
    var totalUndos: Int { freeUndos + adUndos + purchasedUndos }

    @Published var adsWatchedThisLevel: Int = 0
    let maxAdsPerLevel = 3
    var canWatchAd: Bool { adsWatchedThisLevel < maxAdsPerLevel }

    @Published var canUndo: Bool = false
    @Published var isLevelComplete: Bool = false
    @Published var showUndoShop: Bool = false
    @Published var showCelebration: Bool = false
    @Published var completionMessage: String = ""
    @Published var isAnimating: Bool = false
    private var animationStartTime: Date = .distantPast
    @Published var highestLevelCompleted: Int {
        didSet { UserDefaults.standard.set(highestLevelCompleted, forKey: "co_highestLevel") }
    }
    @Published var unlockedBuildingName: String? = nil

    @Published var tutorialStep: Int = 0  // 0 = no tutorial, 1/2/3 = active steps

    var onLevelCompleted: ((Int, Int) -> Void)?

    var moveHistory: [Move] = []
    var totalMovesMade: Int = 0
    var undosUsed: Int = 0

    // MARK: - Computed

    var colorCount: Int { LevelGenerator.colorCount(for: currentLevel) }
    var tubeCapacity: Int { LevelGenerator.tubeCapacity(for: currentLevel) }
    var totalTubes: Int { tubes.count }

    // MARK: - Init

    init() {
        let savedLevel = UserDefaults.standard.integer(forKey: "co_currentLevel")
        self.currentLevel = savedLevel > 0 ? savedLevel : 1
        let savedPurchased = UserDefaults.standard.integer(forKey: "co_purchasedUndos")
        self.purchasedUndos = savedPurchased
        let savedHighest = UserDefaults.standard.integer(forKey: "co_highestLevel")
        self.highestLevelCompleted = savedHighest
        loadLevel()
    }

    // MARK: - Level Management

    func loadLevel() {
        let generated = LevelGenerator.generate(level: currentLevel)
        tubes = generated.tubes
        tubeTargets = generated.targets
        selectedTubeIndex = nil
        moveHistory = []
        canUndo = false
        totalMovesMade = 0
        undosUsed = 0
        isLevelComplete = false
        showCelebration = false
        completionMessage = ""
        unlockedBuildingName = nil
        freeUndos = 3
        adUndos = 0
        adsWatchedThisLevel = 0

        // Show tutorial on Level 1, first time only
        let tutorialSeen = UserDefaults.standard.bool(forKey: "co_tutorialSeen")
        if currentLevel == 1 && !tutorialSeen {
            tutorialStep = 1
        } else {
            tutorialStep = 0
        }
    }

    func advanceTutorial() {
        if tutorialStep < 3 {
            tutorialStep += 1
        } else {
            tutorialStep = 0
            UserDefaults.standard.set(true, forKey: "co_tutorialSeen")
        }
    }

    func dismissTutorial() {
        tutorialStep = 0
        UserDefaults.standard.set(true, forKey: "co_tutorialSeen")
    }

    func restartLevel() {
        loadLevel()
    }

    func nextLevel() {
        currentLevel += 1
        loadLevel()
    }

    func jumpToLevel(_ level: Int) {
        currentLevel = max(1, level)
        loadLevel()
    }

    func startNewGame() {
        currentLevel = 1
        loadLevel()
    }

    // MARK: - Difficulty Label

    static func difficultyLabel(for level: Int) -> (text: String, color: Color)? {
        guard level > 3 else { return nil }

        // Compute base difficulty from actual level parameters
        let colors = LevelGenerator.colorCount(for: level)
        let empties = LevelGenerator.emptyTubeCount(for: level)
        let capacity = LevelGenerator.tubeCapacity(for: level)
        let range = LevelGenerator.targetRange(for: level)

        var base: Double = 0
        base += Double(colors - 3) * 8.0          // 0-40 from color count
        base += Double(range.lowerBound) * 0.5     // ~1.5-17 from move complexity
        base += (empties == 1) ? 6.0 : 0.0         // fewer empties = harder
        base += (capacity == 5) ? 3.0 : 0.0        // larger capacity = slightly harder

        // Seeded random variation per level for unpredictability
        var rng = SeededRandomNumberGenerator(seed: UInt64(level) &* 2654435761 &+ 13)
        let variation = Double.random(in: -20...20, using: &rng)

        let score = max(0, min(100, base + variation))

        switch score {
        case ..<15:  return ("Easy", .green)
        case ..<30:  return ("Medium", .yellow)
        case ..<45:  return ("Hard", .orange)
        case ..<60:  return ("Very Hard", .red)
        case ..<78:  return ("Extreme", Color(red: 1.0, green: 0.2, blue: 0.6))
        default:     return ("Legendary", Color(red: 0.7, green: 0.3, blue: 1.0))
        }
    }

    // MARK: - Tap / Move Logic

    func tapTube(at index: Int) {
        // Auto-recover if isAnimating got stuck (> 0.6s)
        if isAnimating && Date().timeIntervalSince(animationStartTime) > 0.4 {
            isAnimating = false
        }
        guard !isAnimating, !isLevelComplete else { return }

        if let selected = selectedTubeIndex {
            if selected == index {
                withAnimation(.spring(response: 0.3)) {
                    selectedTubeIndex = nil
                }
            } else {
                attemptMove(from: selected, to: index)
                // Advance tutorial after first move
                if tutorialStep == 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        self?.advanceTutorial()
                    }
                }
            }
        } else {
            if !tubes[index].isEmpty {
                withAnimation(.spring(response: 0.3)) {
                    selectedTubeIndex = index
                }
                // Advance tutorial after first selection
                if tutorialStep == 1 {
                    advanceTutorial()
                }
            }
        }
    }

    private func attemptMove(from sourceIndex: Int, to destIndex: Int) {
        guard !tubes[sourceIndex].isEmpty else {
            withAnimation { selectedTubeIndex = nil }
            return
        }

        let topBall = tubes[sourceIndex].last!
        let destTube = tubes[destIndex]
        let capacity = tubeCapacity

        let canMove: Bool
        if destTube.isEmpty {
            canMove = true
        } else if destTube.last?.color == topBall.color && destTube.count < capacity {
            canMove = true
        } else {
            canMove = false
        }

        guard canMove else {
            withAnimation(.spring(response: 0.3)) {
                selectedTubeIndex = nil
            }
            return
        }

        // Count consecutive same-colored balls on top of source
        let sourceTube = tubes[sourceIndex]
        var consecutiveCount = 0
        for i in stride(from: sourceTube.count - 1, through: 0, by: -1) {
            if sourceTube[i].color == topBall.color {
                consecutiveCount += 1
            } else {
                break
            }
        }

        // Move as many as destination can hold
        let availableSpace = capacity - destTube.count
        let moveCount = min(consecutiveCount, availableSpace)

        isAnimating = true
        animationStartTime = Date()
        let ballsToMove = Array(tubes[sourceIndex].suffix(moveCount))
        let move = Move(fromTube: sourceIndex, toTube: destIndex, balls: ballsToMove)

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            tubes[sourceIndex].removeLast(moveCount)
            tubes[destIndex].append(contentsOf: ballsToMove)
            selectedTubeIndex = nil
        }

        moveHistory.append(move)
        canUndo = true
        totalMovesMade += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.isAnimating = false
            self?.checkLevelComplete()
        }
    }

    // MARK: - Undo

    func undo() {
        // Auto-recover if isAnimating got stuck
        if isAnimating && Date().timeIntervalSince(animationStartTime) > 0.4 {
            isAnimating = false
        }
        guard totalUndos > 0, let lastMove = moveHistory.popLast(), !isAnimating else { return }

        isAnimating = true
        animationStartTime = Date()

        // Consume free undos first, then ad undos, then purchased
        if freeUndos > 0 {
            freeUndos -= 1
        } else if adUndos > 0 {
            adUndos -= 1
        } else {
            purchasedUndos -= 1
        }

        undosUsed += 1
        canUndo = !moveHistory.isEmpty
        selectedTubeIndex = nil

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            tubes[lastMove.toTube].removeLast(lastMove.balls.count)
            tubes[lastMove.fromTube].append(contentsOf: lastMove.balls)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            self?.isAnimating = false
        }
    }

    func addUndos(_ count: Int) {
        purchasedUndos += count
    }

    func grantAdReward() {
        guard canWatchAd else { return }
        adUndos += 5
        adsWatchedThisLevel += 1
        showUndoShop = false
    }

    func resetCurrentLevel() {
        loadLevel()
    }

    // MARK: - Win Check

    private func checkLevelComplete() {
        let capacity = tubeCapacity

        // Check each tube against its target
        for (index, tube) in tubes.enumerated() {
            let target = index < tubeTargets.count ? tubeTargets[index] : nil

            if let targetColor = target {
                // Main rod: must be full with all balls matching target color
                guard tube.count == capacity,
                      tube.allSatisfy({ $0.color == targetColor }) else {
                    return
                }
            } else {
                // Workspace rod: must be empty
                guard tube.isEmpty else { return }
            }
        }

        // All conditions met
        highestLevelCompleted = max(highestLevelCompleted, currentLevel)
        unlockedBuildingName = marsNewBuildingName(for: currentLevel)
        completionMessage = computeCompletionMessage()

        // Notify Firebase sync
        onLevelCompleted?(currentLevel + 1, highestLevelCompleted)

        withAnimation(.spring(response: 0.5)) {
            isLevelComplete = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            withAnimation(.easeOut(duration: 0.4)) {
                self?.showCelebration = true
            }
        }
    }

    /// Check if a specific tube is solved (matches its target and is at capacity)
    func isTubeSolved(at index: Int) -> Bool {
        guard index < tubes.count && index < tubeTargets.count else { return false }
        let tube = tubes[index]
        guard let targetColor = tubeTargets[index] else {
            // Workspace tube is "solved" when empty
            return tube.isEmpty
        }
        return tube.count == tubeCapacity && tube.allSatisfy { $0.color == targetColor }
    }

    private func computeCompletionMessage() -> String {
        let colors = LevelGenerator.colorCount(for: currentLevel)
        let rangeUpper = LevelGenerator.targetRange(for: currentLevel).upperBound
        let optimal = colors <= 4 ? rangeUpper : rangeUpper + (colors - 4) * 8
        let effectiveMoves = totalMovesMade + undosUsed * 2
        let ratio = Double(effectiveMoves) / Double(max(optimal, 1))

        if ratio <= 1.0 {
            return "Incredible!"
        } else if ratio <= 1.5 {
            return "Great Job!"
        } else if ratio <= 2.5 {
            return "Good Job!"
        } else {
            return "Phew, That Was Tough!"
        }
    }
}
