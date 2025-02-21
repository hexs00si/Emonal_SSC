import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel

    init() {
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: CalendarViewModel(viewContext: context))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Text("Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()

            WaveHeaderView()
                .padding(.bottom, 16)

            VStack(spacing: 16) {
                // Total Entries Card
                infoCard(
                    title: "Total Entries",
                    value: "\(viewModel.totalEntries)",
                    gradientColors: [Color.white, Color(hex: "F5F5F5")],
                    textColor: .black,
                    emoji: "📖"
                )

                // Day Streak Card with Conditional Styling
                infoCard(
                    title: "Day Streak",
                    value: "\(viewModel.dayStreak)",
                    gradientColors: viewModel.dayStreak == 0 ?
                        [Color(hex: "9C84F6"), Color(hex: "6A4DE0")] : // Lighter Purple Gradient for 0
                        [Color(hex: "F8997D"), Color(hex: "F3696E")], // Warm Gradient for Active Streaks
                    textColor: .black,
                    emoji: viewModel.dayStreak == 0 ? "🌱" : "🔥", // 🌱 if 0, 🔥 otherwise
                    streakMessage: viewModel.dayStreak == 0 ? "Start your journey today!" : "Keep going! You're on a streak!"
                )

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
    
    // Reusable Card Component
    private func infoCard(title: String, value: String, gradientColors: [Color], textColor: Color, emoji: String, streakMessage: String? = nil) -> some View {
        VStack {
            Text(emoji)
                .font(.largeTitle)
                .padding(.bottom, 4)
            
            Text(title)
                .font(.headline)
                .foregroundColor(textColor.opacity(0.8))
            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(textColor)
            if let message = streakMessage {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(textColor.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}
