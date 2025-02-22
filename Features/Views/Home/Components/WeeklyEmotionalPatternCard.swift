import SwiftUI

struct WeeklyEmotionalPatternCard: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title and Subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text("Emotional Wellness Snapshot")
                    .font(.headline)
                    .foregroundColor(.secondary)

                Text("Understand your emotional journey and growth")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Emotional Score Section
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Week")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    HStack(alignment: .bottom) {
                        Text("\(String(format: "%.1f", viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)

                        Text("/ 10")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
                            .foregroundColor(viewModel.weeklyChangeColor)
                    }
                }
            }

            // Progress Indicator
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)

                    Rectangle()
                        .fill(progressColor)
                        .frame(width: progressWidth(in: geometry.size.width), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
        }
        .padding()
        .background(Color(hex: "F0F4F8"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .contentShape(Rectangle()) // Ensure the entire card is tappable
    }

    // Compute progress color based on score
    private var progressColor: Color {
        let score = viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0
        switch score {
        case 0..<4:
            return Color.red.opacity(0.6)
        case 4..<7:
            return Color.yellow.opacity(0.6)
        case 7...10:
            return Color.green.opacity(0.6)
        default:
            return Color.gray.opacity(0.6)
        }
    }

    // Compute progress width based on score
    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        let score = viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0
        return totalWidth * CGFloat(score / 10)
    }
}
