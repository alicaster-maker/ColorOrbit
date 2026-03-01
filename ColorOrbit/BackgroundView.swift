//
//  BackgroundView.swift
//  ColorOrbit
//

import SwiftUI

struct BackgroundView: View {
    var level: Int = 0
    @State private var gradientPhase: Bool = false

    var body: some View {
        ZStack {
            if level >= 1, let bgIndex = backgroundIndex(for: level) {
                // Level-specific background image (each image covers 10 levels)
                GeometryReader { geo in
                    Image("level_bg_\(bgIndex)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                }
                .ignoresSafeArea()

                // Dark overlay so game elements remain readable
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
            } else {
                // Deep space gradient (levels 16+ and home screen)
                LinearGradient(
                    colors: gradientPhase
                        ? [Color(red: 0.01, green: 0.01, blue: 0.10),
                           Color(red: 0.06, green: 0.01, blue: 0.14),
                           Color(red: 0.04, green: 0.02, blue: 0.12)]
                        : [Color(red: 0.03, green: 0.02, blue: 0.12),
                           Color(red: 0.04, green: 0.01, blue: 0.11),
                           Color(red: 0.02, green: 0.03, blue: 0.13)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                        gradientPhase = true
                    }
                }

                // Starfield
                StarfieldView()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)

                // Bottom nebula / cosmic clouds
                VStack {
                    Spacer()
                    ZStack {
                        // Layer 1 — wide purple nebula
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(red: 0.25, green: 0.05, blue: 0.20).opacity(0.35),
                                        Color(red: 0.15, green: 0.02, blue: 0.15).opacity(0.15),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 220
                                )
                            )
                            .frame(width: 500, height: 260)
                            .offset(y: 40)

                        // Layer 2 — warm reddish glow
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(red: 0.35, green: 0.08, blue: 0.08).opacity(0.30),
                                        Color(red: 0.20, green: 0.04, blue: 0.10).opacity(0.12),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 180
                                )
                            )
                            .frame(width: 400, height: 200)
                            .offset(x: -30, y: 60)

                        // Layer 3 — subtle orange accent
                        Ellipse()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color(red: 0.40, green: 0.15, blue: 0.05).opacity(0.18),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 120
                                )
                            )
                            .frame(width: 300, height: 150)
                            .offset(x: 50, y: 80)
                    }
                    .frame(height: 280)
                }
                .ignoresSafeArea()
                .allowsHitTesting(false)
            }
        }
    }

    /// Each image covers 10 levels: image 1 = levels 1-10, image 2 = levels 11-20, ...
    /// Returns nil for levels beyond image 15 (level 151+)
    private func backgroundIndex(for level: Int) -> Int? {
        let index = ((level - 1) / 10) + 1
        return index <= 15 ? index : nil
    }
}

// MARK: - Starfield

private struct StarfieldView: View {
    private let stars: [StarData]

    init() {
        var rng = SeededRandomNumberGenerator(seed: 42)
        var generated: [StarData] = []
        for _ in 0..<100 {
            generated.append(StarData(
                x: CGFloat.random(in: 0...1, using: &rng),
                y: CGFloat.random(in: 0...1, using: &rng),
                size: CGFloat.random(in: 0.8...2.8, using: &rng),
                brightness: Double.random(in: 0.3...1.0, using: &rng),
                twinkleSpeed: Double.random(in: 1.2...3.5, using: &rng)
            ))
        }
        self.stars = generated
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 4.0)) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                for star in stars {
                    let x = star.x * size.width
                    let y = star.y * size.height
                    let twinkle = (sin(time * star.twinkleSpeed) + 1) / 2
                    let opacity = star.brightness * (0.35 + 0.65 * twinkle)

                    context.opacity = opacity
                    let rect = CGRect(
                        x: x - star.size / 2,
                        y: y - star.size / 2,
                        width: star.size,
                        height: star.size
                    )
                    context.fill(Circle().path(in: rect), with: .color(.white))
                }
            }
        }
    }
}

private struct StarData {
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let brightness: Double
    let twinkleSpeed: Double
}

#Preview {
    BackgroundView()
}
