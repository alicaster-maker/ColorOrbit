//
//  ColonyView.swift
//  ColorOrbit
//

import SwiftUI

struct ColonyView: View {
    let level: Int

    private var zone: MarsZone { marsZone(for: level) }
    private var unlocked: Int { marsBuildingsUnlocked(for: level) }

    @State private var blinkOn = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Sky gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color(red: 0.15, green: 0.06, blue: 0.02),
                    Color(red: 0.35, green: 0.12, blue: 0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Stars
            starsLayer

            // Terrain
            terrainLayer

            // Buildings row
            buildingsRow
                .padding(.bottom, 28)

            // Header overlay
            VStack {
                HStack {
                    Text(zone.name)
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(zone.themeColor)

                    Spacer()

                    Text("\(unlocked)/10")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Spacer()
            }
        }
        .frame(height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(zone.themeColor.opacity(0.3), lineWidth: 1)
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                blinkOn = true
            }
        }
    }

    // MARK: - Stars

    private var starsLayer: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            ForEach(0..<15, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.2...0.6)))
                    .frame(width: CGFloat.random(in: 1...2.5), height: CGFloat.random(in: 1...2.5))
                    .position(
                        x: starPos(index: i, max: w),
                        y: starPos(index: i + 50, max: h * 0.5)
                    )
            }
        }
    }

    /// Deterministic pseudo-random position from index
    private func starPos(index: Int, max: CGFloat) -> CGFloat {
        let hash = Double((index * 7919 + 104729) % 10000) / 10000.0
        return CGFloat(hash) * max
    }

    // MARK: - Terrain

    private var terrainLayer: some View {
        VStack(spacing: 0) {
            Spacer()
            // Mars surface
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.55, green: 0.2, blue: 0.08),
                                Color(red: 0.4, green: 0.14, blue: 0.05)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 30)

                // Surface texture lines
                HStack(spacing: 0) {
                    ForEach(0..<20, id: \.self) { i in
                        Rectangle()
                            .fill(Color(red: 0.5, green: 0.18, blue: 0.06).opacity(Double(i % 3 == 0 ? 0.4 : 0.0)))
                            .frame(height: 1)
                    }
                }
                .offset(y: 5)
            }
        }
    }

    // MARK: - Buildings

    private var buildingsRow: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<10, id: \.self) { i in
                let building = zone.buildings[i]
                let isUnlocked = i < unlocked

                ZStack(alignment: .bottom) {
                    BuildingView(shapeType: building.shapeType, unlocked: isUnlocked)

                    // Blinking light for unlocked buildings
                    if isUnlocked {
                        Circle()
                            .fill(blinkColor(for: i))
                            .frame(width: 3, height: 3)
                            .opacity(blinkOn ? 0.9 : 0.2)
                            .offset(y: -2)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 8)
    }

    private func blinkColor(for index: Int) -> Color {
        switch index % 3 {
        case 0: return .red
        case 1: return .yellow
        default: return .cyan
        }
    }
}

#Preview {
    VStack {
        ColonyView(level: 35)
        ColonyView(level: 100)
        ColonyView(level: 155)
    }
    .padding()
    .preferredColorScheme(.dark)
}
