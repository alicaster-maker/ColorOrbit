//
//  GameView.swift
//  ColorOrbit
//

import SwiftUI

struct GameView: View {
    @ObservedObject var gameManager: GameManager
    @ObservedObject var storeManager: StoreManager
    @ObservedObject var adManager: AdManager
    @Environment(\.dismiss) private var dismiss

    @State private var showRestartAlert = false

    var body: some View {
        ZStack {
            // Background
            BackgroundView(level: gameManager.currentLevel)

            // Main layout
            VStack(spacing: 0) {
                // Top bar — fixed height, never clipped
                topBar
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .fixedSize(horizontal: false, vertical: true)
                    .transaction { $0.animation = nil }

                // Abacus board — takes remaining space
                AbacusBoardView(gameManager: gameManager)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)

                // Bottom bar — fixed height, never clipped
                bottomBar
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                    .fixedSize(horizontal: false, vertical: true)
                    .transaction { $0.animation = nil }
            }

            // Tutorial overlay
            if gameManager.tutorialStep > 0 {
                TutorialOverlay(
                    step: gameManager.tutorialStep,
                    onTap: { gameManager.advanceTutorial() },
                    onSkip: { gameManager.dismissTutorial() }
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: gameManager.tutorialStep)
            }

            // Celebration overlay
            if gameManager.showCelebration {
                celebrationOverlay
                    .transition(.opacity)
            }
        }
        .navigationBarHidden(true)
        .alert("Restart Level?", isPresented: $showRestartAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Restart", role: .destructive) {
                gameManager.restartLevel()
            }
        } message: {
            Text("Your progress on this level will be lost.")
        }
        .sheet(isPresented: $gameManager.showUndoShop) {
            UndoShopView(gameManager: gameManager, storeManager: storeManager, adManager: adManager)
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        ZStack {
            // Center — Level info (always perfectly centered)
            VStack(spacing: 2) {
                Text("Level \(gameManager.currentLevel)")
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)

                if let diff = GameManager.difficultyLabel(for: gameManager.currentLevel) {
                    Text(diff.text)
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(diff.color.opacity(0.35))
                        )
                        .overlay(
                            Capsule()
                                .strokeBorder(diff.color.opacity(0.5), lineWidth: 1)
                        )
                } else {
                    // Invisible placeholder to keep height consistent
                    Text(" ")
                        .font(.system(size: 10, weight: .heavy, design: .rounded))
                        .padding(.vertical, 2)
                        .opacity(0)
                }
            }

            // Left — Home + Restart (pinned to leading edge)
            HStack {
                HStack(spacing: 4) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "house.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.85))
                            .frame(width: 40, height: 40)
                    }

                    Button {
                        showRestartAlert = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.85))
                            .frame(width: 40, height: 40)
                    }
                }
                Spacer()
            }

            // Right — Undo + Purchased badge (pinned to trailing edge)
            HStack {
                Spacer()
                HStack(spacing: 6) {
                    // Purchased undos badge
                    Button {
                        gameManager.showUndoShop = true
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: "diamond.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(.cyan.opacity(0.8))
                            Text("\(gameManager.purchasedUndos)")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                                .monospacedDigit()
                                .foregroundStyle(.cyan)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.cyan.opacity(0.08))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(Color.cyan.opacity(0.2), lineWidth: 1)
                                )
                        )
                    }

                    // Undo button (level undos: free + ad)
                    Button {
                        if gameManager.totalUndos > 0 {
                            gameManager.undo()
                        } else {
                            gameManager.showUndoShop = true
                        }
                    } label: {
                        HStack(spacing: 4) {
                            if gameManager.totalUndos == 0 && gameManager.canUndo {
                                Image(systemName: "play.rectangle.fill")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.orange)
                                Text("Ad +5")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(.orange)
                            } else {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(gameManager.canUndo ? 1 : 0.4))
                                Text("\(gameManager.freeUndos + gameManager.adUndos)")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .monospacedDigit()
                                    .foregroundStyle(gameManager.canUndo ? .white : .white.opacity(0.4))
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(gameManager.totalUndos == 0 && gameManager.canUndo
                                      ? Color.orange.opacity(0.15)
                                      : Color.white.opacity(0.1))
                                .overlay(
                                    Capsule()
                                        .strokeBorder(gameManager.totalUndos == 0 && gameManager.canUndo
                                                      ? Color.orange.opacity(0.4) : Color.clear, lineWidth: 1)
                                )
                        )
                    }
                    .disabled(!gameManager.canUndo)
                }
            }
        }
        .frame(height: 52)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial.opacity(0.6))
        )
    }

    // MARK: - Bottom Bar

    private var bottomBar: some View {
        HStack {
            Text("Moves: \(gameManager.totalMovesMade)")
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .monospacedDigit()
                .foregroundStyle(.white.opacity(0.5))

            Spacer()

            Text("\(gameManager.colorCount) colors")
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(height: 20)
    }

    // MARK: - Celebration Overlay

    private var celebrationOverlay: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: 20) {
                // Starburst
                StarburstView()
                    .frame(width: 120, height: 120)

                Text("Level \(gameManager.currentLevel)")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white.opacity(0.7))

                Text("Complete!")
                    .font(.system(.largeTitle, design: .rounded, weight: .heavy))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.9, blue: 0.5),
                                Color(red: 1.0, green: 0.7, blue: 0.3)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(gameManager.completionMessage)
                    .font(.system(.title3, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))

                // Milestone building unlock
                if let buildingName = gameManager.unlockedBuildingName {
                    VStack(spacing: 4) {
                        Text("New Structure Unlocked:")
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
                        Text(buildingName)
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.orange, .yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                Button {
                    gameManager.nextLevel()
                } label: {
                    Text("Next Level")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 220)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 1.0, green: 0.9, blue: 0.5),
                                            Color(red: 1.0, green: 0.75, blue: 0.35)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        )
                        .shadow(color: .orange.opacity(0.4), radius: 10)
                }
                .padding(.top, 10)
            }
        }
    }
}

// MARK: - Starburst Effect

// MARK: - Tutorial Overlay

private struct TutorialOverlay: View {
    let step: Int
    let onTap: () -> Void
    let onSkip: () -> Void

    private var title: String {
        switch step {
        case 1: return "Tap a Tube"
        case 2: return "Move the Balls"
        case 3: return "Sort All Colors!"
        default: return ""
        }
    }

    private var message: String {
        switch step {
        case 1: return "Tap on a tube to pick up the top balls."
        case 2: return "Now tap another tube to drop them.\nBalls can only go on matching colors\nor into empty tubes."
        case 3: return "Match all balls to their target colors\nto complete the level. Have fun!"
        default: return ""
        }
    }

    private var icon: String {
        switch step {
        case 1: return "hand.tap"
        case 2: return "arrow.up.and.down"
        case 3: return "checkmark.circle"
        default: return "questionmark"
        }
    }

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture { onTap() }

            VStack(spacing: 16) {
                // Step indicator
                HStack(spacing: 6) {
                    ForEach(1...3, id: \.self) { i in
                        Capsule()
                            .fill(i <= step ? Color.orange : Color.white.opacity(0.3))
                            .frame(width: i == step ? 24 : 8, height: 4)
                    }
                }

                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.9, blue: 0.5), .orange],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text(title)
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)

                Text(message)
                    .font(.system(.callout, design: .rounded, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                // Buttons
                HStack(spacing: 12) {
                    if step < 3 {
                        Button {
                            onSkip()
                        } label: {
                            Text("Skip")
                                .font(.system(.subheadline, design: .rounded, weight: .medium))
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        }
                    }

                    Button {
                        onTap()
                    } label: {
                        Text(step < 3 ? "Next" : "Let's Go!")
                            .font(.system(.subheadline, design: .rounded, weight: .bold))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color(red: 1.0, green: 0.9, blue: 0.5),
                                                Color(red: 1.0, green: 0.75, blue: 0.35)
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                    }
                }
                .padding(.top, 4)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.4), radius: 20)
            )
            .padding(.horizontal, 40)
        }
    }
}

// MARK: - Starburst Effect

private struct StarburstView: View {
    @State private var rotation: Double = 0
    @State private var scale: CGFloat = 0.5

    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { i in
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.yellow, .orange.opacity(0.3)],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 3, height: 40)
                    .offset(y: -35)
                    .rotationEffect(.degrees(Double(i) * 30))
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white, .yellow, .orange],
                        center: .center,
                        startRadius: 0,
                        endRadius: 20
                    )
                )
                .frame(width: 30, height: 30)
        }
        .rotationEffect(.degrees(rotation))
        .scaleEffect(scale)
        .onAppear {
            withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
    }
}
