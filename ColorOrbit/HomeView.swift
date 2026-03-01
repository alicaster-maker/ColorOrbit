//
//  HomeView.swift
//  ColorOrbit
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var playerManager: PlayerManager
    @StateObject private var gameManager = GameManager()
    @StateObject private var storeManager = StoreManager()
    @StateObject private var adManager = AdManager()
    @State private var showNewGameAlert = false
    @State private var navigateToGame = false
    @State private var showJumpAlert = false
    @State private var jumpLevelText = ""
    @State private var showLeaderboard = false

    var body: some View {
        VStack(spacing: 30) {
            // Top bar with nickname + social buttons
            HStack {
                if let nickname = playerManager.nickname {
                    Text(nickname)
                        .font(.system(.callout, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.8))
                }

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        showLeaderboard = true
                    } label: {
                        Image(systemName: "trophy.fill")
                            .font(.title2)
                            .foregroundStyle(.yellow)
                    }

                    Button {
                        InviteHelper.shareInvite(playerManager: playerManager)
                    } label: {
                        Image(systemName: "person.badge.plus")
                            .font(.title2)
                            .foregroundStyle(.cyan)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(.ultraThinMaterial.opacity(0.8))
                )
            }
            .padding(.horizontal, 20)

            Spacer()

            // Mars Colony (with level info)
            ColonyView(level: gameManager.currentLevel)
                .padding(.horizontal, 16)
                .onLongPressGesture {
                    jumpLevelText = ""
                    showJumpAlert = true
                }

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
                GameView(gameManager: gameManager, storeManager: storeManager, adManager: adManager)
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
        .background {
            Image("ColorOrbitMain")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showLeaderboard) {
            LeaderboardView(playerManager: playerManager)
        }
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
        .onAppear {
            gameManager.onLevelCompleted = { [weak playerManager] current, highest in
                playerManager?.syncLevel(current: current, highest: highest)
            }

            // Bidirectional sync: take the higher of local vs remote
            let remoteHighest = playerManager.remoteHighestLevel
            if remoteHighest > gameManager.highestLevelCompleted {
                gameManager.highestLevelCompleted = remoteHighest
            }

            // Push current local state to Firestore
            playerManager.syncLevel(
                current: gameManager.currentLevel,
                highest: gameManager.highestLevelCompleted
            )
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(playerManager: PlayerManager())
    }
    .preferredColorScheme(.dark)
}
