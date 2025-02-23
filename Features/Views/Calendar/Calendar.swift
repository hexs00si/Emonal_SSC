import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    @State private var selectedDate: Date?
    @State private var showEntriesModal = false
    
    init() {
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: CalendarViewModel(viewContext: context))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Calendar Heading
                Text("Calendar")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Calendar Grid
                CalendarGrid(selectedDate: $selectedDate, averageMoodScores: viewModel.averageMoodScores)
                    .padding(.horizontal)
                
                // Information note
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .foregroundColor(.secondary)
                    Text("Tap on an emoji 😊 to view that day's journal entries")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, -8)

                // Day Streak Card
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
                .padding(.horizontal)

                // Total Entries Card
                infoCard(
                    title: "Total Entries",
                    value: "\(viewModel.totalEntries)",
                    gradientColors: [Color.white, Color(hex: "F5F5F5")],
                    textColor: .black,
                    emoji: "📖"
                )
                .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        .onChange(of: selectedDate) { newDate in
            // Show the modal when a date with entries is selected
            if newDate != nil {
                showEntriesModal = true
            }
        }
        .sheet(isPresented: $showEntriesModal) {
            if let selectedDate = selectedDate {
                JournalEntriesModal(date: selectedDate, viewModel: viewModel)
            }
        }
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
