import SwiftUI

struct WeeklyEmotionalPatternCard: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Your Emotional Wellness")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("Track your emotions and well-being over time")
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
            }

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

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 8)

                    Capsule()
                        .fill(progressColor)
                        .frame(width: progressWidth(in: geometry.size.width), height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(gradientBackground)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .contentShape(Rectangle())
    }

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

    private func progressWidth(in totalWidth: CGFloat) -> CGFloat {
        let score = viewModel.weeklyEmotionalScore.isFinite ? viewModel.weeklyEmotionalScore : 0
        return totalWidth * CGFloat(score / 10)
    }

    private var gradientBackground: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
