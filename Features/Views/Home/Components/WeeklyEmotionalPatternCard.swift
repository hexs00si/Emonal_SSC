import SwiftUI

struct WeeklyEmotionalPatternCard: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text("Emotional Wellness Snapshot")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Understand your emotional journey and growth")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
            }

            // Emotional Score Section
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Week")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))

                    HStack(alignment: .bottom) {
                        Text("\(String(format: "%.1f", viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0))")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("/ 10")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                Spacer()

                // Trend Indicator
                if !viewModel.weeklyChangeText.contains("nan") {
                    HStack {
                        Image(systemName: viewModel.weeklyChangeText.contains("↑") ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(viewModel.weeklyChangeText.contains("↑") ? .green : .red)

                        Text(viewModel.weeklyChangeText.replacingOccurrences(of: "↑", with: "").replacingOccurrences(of: "↓", with: ""))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }

            // Progress Indicator
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 8)
                        .cornerRadius(4)

                    Rectangle()
                        .fill(progressColor)
                        .frame(width: progressWidth(in: geometry.size.width), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(gradientBackground) // Modern Gradient
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .contentShape(Rectangle()) // Ensure entire card is tappable
    }

    // Compute progress color based on score
    private var progressColor: Color {
        let score = viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0
        switch score {
        case 0..<4:
            return Color.red.opacity(0.8)
        case 4..<7:
            return Color.yellow.opacity(0.8)
        case 7...10:
            return Color.green.opacity(0.8)
        default:
            return Color.gray.opacity(0.6)
        }
    }

    // Compute progress width based on score
    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        let score = viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0
        return totalWidth * CGFloat(score / 10)
    }

    // Modern gradient background
    private var gradientBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
