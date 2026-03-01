//
//  BallView.swift
//  ColorOrbit
//

import SwiftUI

struct BallView: View {
    let color: BallColor
    let size: CGFloat

    var body: some View {
        ZStack {
            // Outer color glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [color.uiColor.opacity(0.6), color.uiColor.opacity(0.0)],
                        center: .center,
                        startRadius: size * 0.3,
                        endRadius: size * 0.65
                    )
                )
                .frame(width: size * 1.3, height: size * 1.3)

            // Main orb — rich gradient from bright center to saturated edge
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            color.uiColor.opacity(0.55),
                            color.uiColor,
                            color.uiColor.opacity(0.75)
                        ],
                        center: .init(x: 0.38, y: 0.32),
                        startRadius: 0,
                        endRadius: size * 0.52
                    )
                )
                .frame(width: size, height: size)

            // Rim edge darkening
            Circle()
                .strokeBorder(
                    RadialGradient(
                        colors: [.clear, color.uiColor.opacity(0.4)],
                        center: .center,
                        startRadius: size * 0.3,
                        endRadius: size * 0.5
                    ),
                    lineWidth: size * 0.08
                )
                .frame(width: size, height: size)

            // Specular highlight — top-left crescent
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.92), .white.opacity(0.0)],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.22
                    )
                )
                .frame(width: size * 0.40, height: size * 0.30)
                .offset(x: -size * 0.12, y: -size * 0.16)

            // Secondary soft highlight — bottom-right bounce light
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.15), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.15
                    )
                )
                .frame(width: size * 0.25, height: size * 0.18)
                .offset(x: size * 0.14, y: size * 0.16)
        }
        .shadow(color: color.uiColor.opacity(0.55), radius: size * 0.2)
        .drawingGroup(opaque: false)
    }
}

#Preview {
    HStack(spacing: 20) {
        ForEach(BallColor.allCases.prefix(4), id: \.self) { color in
            BallView(color: color, size: 40)
        }
    }
    .padding()
    .background(.black)
}
