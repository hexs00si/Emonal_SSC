import SwiftUI

struct WaveHeaderView: View {
    var body: some View {
        // Minimalistic gradient bar with a soft shadow for depth
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "8B5DFF").opacity(0.8),
                        Color(hex: "6A4DE0").opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 8) // Slightly thicker than a line for visual interest
            .padding(.horizontal, 16)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2) // Subtle shadow for depth
    }
}
