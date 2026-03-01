//
//  UndoShopView.swift
//  ColorOrbit
//

import SwiftUI
import StoreKit

struct UndoShopView: View {
    @ObservedObject var gameManager: GameManager
    @ObservedObject var storeManager: StoreManager
    @Environment(\.dismiss) private var dismiss

    @State private var isWatchingAd = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.06, blue: 0.15),
                    Color(red: 0.1, green: 0.08, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Title
                Text("Need More Undos?")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .padding(.top, 28)

                // Watch Ad Button
                Button {
                    isWatchingAd = true
                    gameManager.watchAdForUndos()
                } label: {
                    HStack(spacing: 10) {
                        if isWatchingAd {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Image(systemName: "play.fill")
                        }
                        Text(isWatchingAd ? "Watching..." : "Watch Ad → +3 Free")
                            .font(.system(.body, design: .rounded, weight: .bold))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.85, blue: 0.4),
                                        Color(red: 0.2, green: 0.7, blue: 0.3)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
                    .shadow(color: .green.opacity(0.3), radius: 8)
                }
                .disabled(isWatchingAd)
                .padding(.horizontal, 32)

                // Divider
                HStack {
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 1)
                    Text("or purchase")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                    Rectangle()
                        .fill(.white.opacity(0.2))
                        .frame(height: 1)
                }
                .padding(.horizontal, 24)

                // IAP Buttons
                VStack(spacing: 12) {
                    ForEach(storeManager.products, id: \.id) { product in
                        iapButton(product: product)
                    }

                    // Fallback when products haven't loaded
                    if storeManager.products.isEmpty {
                        iapPlaceholder(undos: 15, price: "$0.99")
                        iapPlaceholder(undos: 50, price: "$2.99")
                        iapPlaceholder(undos: 200, price: "$9.99")
                    }
                }
                .padding(.horizontal, 32)

                Spacer()

                // No Thanks
                Button {
                    dismiss()
                } label: {
                    Text("No Thanks")
                        .font(.system(.body, design: .rounded, weight: .medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.vertical, 12)
                }
                .padding(.bottom, 20)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    // MARK: - IAP Button (live product)

    private func iapButton(product: Product) -> some View {
        Button {
            Task {
                await storeManager.purchase(product, gameManager: gameManager)
                dismiss()
            }
        } label: {
            HStack {
                let undoCount = undoLabel(for: product.id)
                Text("\(undoCount) Undos")
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                Text(product.displayPrice)
                    .font(.system(.body, design: .rounded, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                    )
            )
        }
        .disabled(storeManager.isPurchasing)
    }

    // MARK: - IAP Placeholder (before products load)

    private func iapPlaceholder(undos: Int, price: String) -> some View {
        HStack {
            Text("\(undos) Undos")
                .font(.system(.body, design: .rounded, weight: .semibold))
                .foregroundStyle(.white.opacity(0.4))
            Spacer()
            Text(price)
                .font(.system(.body, design: .rounded, weight: .bold))
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private func undoLabel(for productID: String) -> Int {
        switch productID {
        case "co_undo_15":  return 15
        case "co_undo_50":  return 50
        case "co_undo_200": return 200
        default:            return 0
        }
    }
}
