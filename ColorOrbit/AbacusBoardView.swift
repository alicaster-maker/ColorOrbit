//
//  AbacusBoardView.swift
//  ColorOrbit
//

import SwiftUI

struct AbacusBoardView: View {
    @ObservedObject var gameManager: GameManager
    @Namespace private var ballNamespace

    private var tubeCount: Int { gameManager.tubes.count }
    private var usesTwoRows: Bool { tubeCount > 5 }

    private var topRowCount: Int {
        if !usesTwoRows { return tubeCount }
        return (tubeCount + 1) / 2
    }
    private var bottomRowCount: Int {
        if !usesTwoRows { return 0 }
        return tubeCount - topRowCount
    }

    var body: some View {
        GeometryReader { geo in
            let colsPerRow = usesTwoRows ? topRowCount : tubeCount
            let layout = AbacusLayout.calculate(
                columnsPerRow: colsPerRow,
                capacity: gameManager.tubeCapacity,
                rows: usesTwoRows ? 2 : 1,
                availableWidth: geo.size.width,
                availableHeight: geo.size.height
            )

            let frameWidth = layout.frameWidth
            let frameHeight = layout.frameHeight

            ZStack {
                // Wooden frame
                woodenFrame(width: frameWidth, height: frameHeight)

                VStack(spacing: 0) {
                    if usesTwoRows {
                        // Top row
                        indicatorRow(startIndex: 0, count: topRowCount, layout: layout)
                            .padding(.top, layout.framePadding)
                        separator(layout: layout)
                        columnRow(startIndex: 0, count: topRowCount, layout: layout)
                            .padding(.top, 4)

                        // Row divider
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(height: 2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, layout.rowGap / 2)

                        // Bottom row
                        indicatorRow(startIndex: topRowCount, count: bottomRowCount, layout: layout)
                        separator(layout: layout)
                        columnRow(startIndex: topRowCount, count: bottomRowCount, layout: layout)
                            .padding(.top, 4)
                            .padding(.bottom, layout.framePadding)
                    } else {
                        // Single row
                        indicatorRow(startIndex: 0, count: tubeCount, layout: layout)
                            .padding(.top, layout.framePadding)
                        separator(layout: layout)
                        columnRow(startIndex: 0, count: tubeCount, layout: layout)
                            .padding(.top, 4)
                            .padding(.bottom, layout.framePadding)
                    }
                }
                .frame(width: frameWidth, height: frameHeight)
            }
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }

    // MARK: - Wooden Frame

    private func woodenFrame(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial.opacity(0.5))

            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.25),
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
        }
        .frame(width: width, height: height)
    }

    // MARK: - Separator

    private func separator(layout: AbacusLayout) -> some View {
        Rectangle()
            .fill(Color.white.opacity(0.12))
            .frame(height: 1)
            .padding(.horizontal, layout.framePadding)
            .padding(.top, 5)
    }

    // MARK: - Indicator Row

    private func indicatorRow(startIndex: Int, count: Int, layout: AbacusLayout) -> some View {
        HStack(spacing: layout.columnSpacing) {
            ForEach(0..<count, id: \.self) { i in
                let index = startIndex + i
                let target = index < gameManager.tubeTargets.count ? gameManager.tubeTargets[index] : nil
                targetIndicator(target: target, size: layout.indicatorSize)
                    .frame(width: layout.columnWidth)
            }
        }
        .padding(.horizontal, layout.framePadding)
    }

    private func targetIndicator(target: BallColor?, size: CGFloat) -> some View {
        ZStack {
            if let color = target {
                Circle()
                    .fill(color.uiColor)
                    .frame(width: size, height: size)
                    .shadow(color: color.uiColor.opacity(0.5), radius: 4)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [.white.opacity(0.5), .clear],
                            center: .init(x: 0.35, y: 0.30),
                            startRadius: 0,
                            endRadius: size * 0.4
                        )
                    )
                    .frame(width: size * 0.7, height: size * 0.7)
                    .offset(x: -size * 0.08, y: -size * 0.08)
            } else {
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: size, height: size)

                Circle()
                    .strokeBorder(
                        Color.white.opacity(0.25),
                        style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
                    )
                    .frame(width: size, height: size)
            }
        }
    }

    // MARK: - Column Row

    private func columnRow(startIndex: Int, count: Int, layout: AbacusLayout) -> some View {
        HStack(spacing: layout.columnSpacing) {
            ForEach(0..<count, id: \.self) { i in
                let index = startIndex + i
                let balls = gameManager.tubes[index]
                let target = index < gameManager.tubeTargets.count ? gameManager.tubeTargets[index] : nil
                let isSolved = gameManager.isTubeSolved(at: index)

                ColumnView(
                    balls: balls,
                    capacity: gameManager.tubeCapacity,
                    targetColor: target,
                    isSelected: gameManager.selectedTubeIndex == index,
                    isSolved: isSolved,
                    ballSize: layout.ballSize,
                    namespace: ballNamespace
                )
                .frame(width: layout.columnWidth)
                .onTapGesture {
                    gameManager.tapTube(at: index)
                }
            }
        }
        .padding(.horizontal, layout.framePadding)
    }
}

// MARK: - Layout Calculator

struct AbacusLayout {
    let ballSize: CGFloat
    let columnWidth: CGFloat
    let columnSpacing: CGFloat
    let frameWidth: CGFloat
    let frameHeight: CGFloat
    let framePadding: CGFloat
    let indicatorSize: CGFloat
    let rowGap: CGFloat

    static func calculate(
        columnsPerRow: Int, capacity: Int, rows: Int,
        availableWidth: CGFloat, availableHeight: CGFloat
    ) -> AbacusLayout {
        let framePadding: CGFloat = 14
        let edgeInset: CGFloat = 8

        let spacing: CGFloat = max(4, min(10, availableWidth / CGFloat(columnsPerRow + 1) * 0.12))
        let usableWidth = availableWidth - edgeInset * 2
        let totalGaps = spacing * CGFloat(columnsPerRow - 1) + framePadding * 2
        let maxBallFromWidth = (usableWidth - totalGaps) / CGFloat(columnsPerRow) - 16

        let slotExtra: CGFloat = 8
        let slotGap: CGFloat = 5
        let sectionHeaderHeight: CGFloat = 38
        let rowGap: CGFloat = rows > 1 ? 14 : 0
        let verticalChrome = framePadding * 2
            + sectionHeaderHeight * CGFloat(rows)
            + rowGap * CGFloat(rows - 1)
            + 10
        let totalColumnHeight = availableHeight - verticalChrome
        let perRowColumnHeight = totalColumnHeight / CGFloat(rows)
        let maxBallFromHeight = perRowColumnHeight / CGFloat(capacity) - slotGap - slotExtra

        let ballSize = max(16, min(maxBallFromWidth, maxBallFromHeight, 36))
        let columnWidth = ballSize + 14

        let slotSize = ballSize + slotExtra
        let indicatorSize = min(ballSize * 0.7, 26)
        let indicatorRowHeight = indicatorSize + 8
        let separatorHeight: CGFloat = 7
        let columnHeight = CGFloat(capacity) * (slotSize + slotGap) + 10

        let frameWidth = CGFloat(columnsPerRow) * columnWidth
            + CGFloat(columnsPerRow - 1) * spacing
            + framePadding * 2

        let singleSectionHeight = indicatorRowHeight + separatorHeight + columnHeight + 4
        let frameHeight = framePadding * 2
            + singleSectionHeight * CGFloat(rows)
            + rowGap * CGFloat(rows - 1)

        return AbacusLayout(
            ballSize: ballSize,
            columnWidth: columnWidth,
            columnSpacing: spacing,
            frameWidth: frameWidth,
            frameHeight: frameHeight,
            framePadding: framePadding,
            indicatorSize: indicatorSize,
            rowGap: rowGap
        )
    }
}
