//
//  Models.swift
//  ColorOrbit
//

import SwiftUI

// MARK: - Ball Color

enum BallColor: String, CaseIterable, Codable {
    case red, blue, green, orange, purple, cyan, yellow, pink

    var displayName: String {
        switch self {
        case .red:    return "Mars Red"
        case .blue:   return "Neptune Blue"
        case .green:  return "Aurora Green"
        case .orange: return "Solar Orange"
        case .purple: return "Nebula Purple"
        case .cyan:   return "Comet Cyan"
        case .yellow: return "Star Yellow"
        case .pink:   return "Quasar Pink"
        }
    }

    var uiColor: Color {
        switch self {
        case .red:    return Color(red: 1.0,  green: 0.20, blue: 0.18)
        case .blue:   return Color(red: 0.15, green: 0.45, blue: 1.0)
        case .green:  return Color(red: 0.10, green: 0.88, blue: 0.40)
        case .orange: return Color(red: 1.0,  green: 0.55, blue: 0.05)
        case .purple: return Color(red: 0.62, green: 0.15, blue: 1.0)
        case .cyan:   return Color(red: 0.0,  green: 0.92, blue: 1.0)
        case .yellow: return Color(red: 1.0,  green: 0.92, blue: 0.0)
        case .pink:   return Color(red: 1.0,  green: 0.30, blue: 0.58)
        }
    }

    /// Canonical index for bit-packing in solver (1-8).
    var rawIndex: Int {
        switch self {
        case .red:    return 1
        case .blue:   return 2
        case .green:  return 3
        case .orange: return 4
        case .purple: return 5
        case .cyan:   return 6
        case .yellow: return 7
        case .pink:   return 8
        }
    }
}

// MARK: - Ball

struct Ball: Identifiable, Equatable {
    let color: BallColor
    let id: UUID

    init(color: BallColor, id: UUID = UUID()) {
        self.color = color
        self.id = id
    }
}

// MARK: - Move

struct Move: Equatable {
    let fromTube: Int
    let toTube: Int
    let balls: [Ball]
}
