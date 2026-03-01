//
//  AdManager.swift
//  ColorOrbit
//

import GoogleMobileAds
import SwiftUI

@MainActor
final class AdManager: NSObject, ObservableObject {

    // MARK: - Published State

    @Published var isAdLoaded = false
    @Published var isAdShowing = false

    // MARK: - Private

    // Google test rewarded ad unit ID
    private let adUnitID = "ca-app-pub-3940256099942544/1712485313"
    private var rewardedAd: RewardedAd?
    private var rewardEarned = false

    // Continuation used to bridge delegate callbacks → async
    private var showContinuation: CheckedContinuation<Bool, Never>?

    // MARK: - Load

    func loadAd() {
        Task {
            do {
                rewardedAd = try await RewardedAd.load(
                    with: adUnitID,
                    request: Request()
                )
                rewardedAd?.fullScreenContentDelegate = self
                isAdLoaded = true
            } catch {
                print("[AdManager] Failed to load rewarded ad: \(error.localizedDescription)")
                isAdLoaded = false
            }
        }
    }

    // MARK: - Show

    /// Shows a rewarded ad and returns `true` if the user earned the reward.
    func showRewardedAd() async -> Bool {
        guard let ad = rewardedAd, let rootVC = rootViewController() else {
            return false
        }

        isAdShowing = true
        rewardEarned = false

        return await withCheckedContinuation { continuation in
            self.showContinuation = continuation
            ad.present(from: rootVC) {
                self.rewardEarned = true
            }
        }
    }

    // MARK: - Helpers

    private func rootViewController() -> UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController
        else { return nil }

        var vc = root
        while let presented = vc.presentedViewController {
            vc = presented
        }
        return vc
    }
}

// MARK: - FullScreenContentDelegate

extension AdManager: FullScreenContentDelegate {

    nonisolated func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        Task { @MainActor in
            isAdShowing = false
            let earned = rewardEarned
            showContinuation?.resume(returning: earned)
            showContinuation = nil

            // Reset and preload next ad
            rewardedAd = nil
            isAdLoaded = false
            loadAd()
        }
    }

    nonisolated func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            print("[AdManager] Ad failed to present: \(error.localizedDescription)")
            isAdShowing = false
            showContinuation?.resume(returning: false)
            showContinuation = nil

            rewardedAd = nil
            isAdLoaded = false
            loadAd()
        }
    }
}
