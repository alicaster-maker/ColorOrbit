//
//  HomeView.swift
//  ColorOrbit
//

import SwiftUI

struct HomeView: View {
    @StateObject private var gameManager = GameManager()
    @StateObject private var storeManager = StoreManager()
    @State private var showNewGameAlert = false
    @State private var navigateToGame = false
    @State private var showJumpAlert = false
    @State private var jumpLevelText = ""

    var body: some View {
        ZStack {
            BackgroundView()

            VStack(spacing: 30) {
                Spacer()

                // Title
                VStack(spacing: 8) {
                    Text("COLOR")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("ORBIT")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color(red: 1.0, green: 0.9, blue: 0.5),
                                    Color(red: 1.0, green: 0.7, blue: 0.3)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
                .shadow(color: .cyan.opacity(0.3), radius: 20)

                // Level indicator (long press to jump)
                Text("Level \(gameManager.currentLevel)")
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .foregroundStyle(.white.opacity(0.6))
                    .onLongPressGesture {
                        jumpLevelText = ""
                        showJumpAlert = true
                    }

                // Mars Colony
                ColonyView(level: gameManager.highestLevelCompleted)
                    .padding(.horizontal, 16)

                Spacer()

                // Play / Continue button
                Button {
                    navigateToGame = true
                } label: {
                    Text(gameManager.currentLevel > 1 ? "Continue" : "Play")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: 260)
                        .padding(.vertical, 16)
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
                        .shadow(color: .orange.opacity(0.4), radius: 12)
                }
                .navigationDestination(isPresented: $navigateToGame) {
                    GameView(gameManager: gameManager, storeManager: storeManager)
                }

                // New Game button
                if gameManager.currentLevel > 1 {
                    Button {
                        showNewGameAlert = true
                    } label: {
                        Text("New Game")
                            .font(.system(.callout, design: .rounded, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 24)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.1))
                            )
                    }
                }

                Spacer()
                    .frame(height: 60)
            }
        }
        .navigationBarHidden(true)
        .alert("Start New Game?", isPresented: $showNewGameAlert) {
            Button("Cancel", role: .cancel) { }
            Button("New Game", role: .destructive) {
                gameManager.startNewGame()
            }
        } message: {
            Text("This will reset your progress to Level 1.")
        }
        .alert("Jump to Level", isPresented: $showJumpAlert) {
            TextField("Level number", text: $jumpLevelText)
                .keyboardType(.numberPad)
            Button("Cancel", role: .cancel) { }
            Button("Go") {
                if let lvl = Int(jumpLevelText), lvl >= 1 {
                    gameManager.jumpToLevel(lvl)
                }
            }
        } message: {
            Text("Enter a level number to jump to.")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.dark)
}
