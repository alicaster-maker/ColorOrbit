//
//  ColorOrbitApp.swift
//  ColorOrbit
//

import SwiftUI

@main
struct ColorOrbitApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
            .preferredColorScheme(.dark)
        }
    }
}
