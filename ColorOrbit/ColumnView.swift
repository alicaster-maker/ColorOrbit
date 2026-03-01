//
//  ColumnView.swift
//  ColorOrbit
//

import SwiftUI

struct ColumnView: View {
    let balls: [Ball]
    let capacity: Int
    let targetColor: BallColor?
    let isSelected: Bool
    let isSolved: Bool
    let ballSize: CGFloat
    var namespace: Namespace.ID

    @State private var shimmerPhase: CGFloat = -0.5

    private var slotSize: CGFloat { ballSize + 8 }
    private var slotSpacing: CGFloat { 5 }
    private var columnHeight: CGFloat {
        CGFloat(capacity) * (slotSize + slotSpacing) + 10
    }

    var body: some View {
        ZStack {
            // Column background
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(white: 0.06).opacity(0.6))

            // Selection highlight
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.85, blue: 0.4),
                                Color(red: 1.0, green: 0.65, blue: 0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2.5
                    )
            }

            // Solved glow
            if isSolved && targetColor != nil {
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color(red: 0.3, green: 1.0, blue: 0.5).opacity(0.7),
                                Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.5)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
            }

            // Solved shimmer sweep
            if isSolved && targetColor != nil {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.15), .clear],
                            startPoint: UnitPoint(x: 0.5, y: shimmerPhase),
                            endPoint: UnitPoint(x: 0.5, y: shimmerPhase + 0.25)
                        )
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                            shimmerPhase = 1.5
                        }
                    }
            }

            // Ball slots — stacked vertically, bottom-up
            VStack(spacing: slotSpacing) {
                ForEach((0..<capacity).reversed(), id: \.self) { position in
                    ZStack {
                        // Slot background
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.03))
                        RoundedRectangle(cornerRadius: 4)
                            .strokeBorder(
                                Color.white.opacity(position < balls.count ? 0.05 : 0.10),
                                lineWidth: 0.5
                            )

                        // Ball if present at this position
                        if position < balls.count {
                            BallView(color: balls[position].color, size: ballSize)
                                .matchedGeometryEffect(id: balls[position].id, in: namespace)
                                .transition(.identity)
                        }
                    }
                    .frame(width: slotSize, height: slotSize)
                }
            }
            .padding(.vertical, 5)
        }
        .frame(height: columnHeight)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .shadow(
            color: isSelected
                ? Color(red: 1.0, green: 0.75, blue: 0.3).opacity(0.5)
                : isSolved && targetColor != nil
                    ? Color(red: 0.3, green: 1.0, blue: 0.5).opacity(0.3)
                    : .clear,
            radius: isSelected ? 10 : isSolved ? 6 : 0
        )
        .contentShape(Rectangle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
