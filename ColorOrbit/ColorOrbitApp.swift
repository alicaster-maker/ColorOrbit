//
//  ColorOrbitApp.swift
//  ColorOrbit
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start()
        return true
    }
}

@main
struct ColorOrbitApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var playerManager = PlayerManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView(playerManager: playerManager)
            }
            .preferredColorScheme(.dark)
            .onOpenURL { url in
                Task {
                    await playerManager.handleDeepLink(url)
                }
            }
        }
    }
}
