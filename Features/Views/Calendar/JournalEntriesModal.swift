import SwiftUI
import CoreData

struct JournalEntriesModal: View {
    let date: Date
    @ObservedObject var viewModel: CalendarViewModel
    @State private var emojiAnimationAngle: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            // Modal Header
            VStack(spacing: 8) {
                Text(date.formatted(.dateTime.month(.wide).day().year()))
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Average Mood Emoji with Revolving Emojis
                if let averageMoodEmoji = viewModel.averageMoodScores[date] {
                    ZStack {
                        // Average Mood Emoji
                        Text(averageMoodEmoji)
                            .font(.system(size: 50))
                            .padding()
                            .background(Circle().fill(Color.white).shadow(radius: 5))
                        
                        // Revolving Emojis
                        RevolvingEmojis(entries: viewModel.fetchEntries(for: date), emojiAnimationAngle: $emojiAnimationAngle)
                    }
                    .frame(width: 150, height: 150) // Fixed size for the ZStack
                    .onAppear {
                        // Start the emoji animation
                        withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: false)) {
                            emojiAnimationAngle = 2 * .pi
                        }
                    }
                }
            }

            // Journal Entries List
            ScrollView {
                VStack(spacing: 16) {
                    // Fetch entries for the selected date
                    let entriesForDate = viewModel.fetchEntries(for: date)
                    
                    if entriesForDate.isEmpty {
                        Text("No entries for this day.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(entriesForDate, id: \.id) { entry in
                            CalendarEntryView(entry: entry)
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding()
    }
}
