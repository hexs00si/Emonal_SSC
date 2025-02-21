import SwiftUI

struct CalendarEntryView: View {
    let entry: JournalEntry
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a" // Only show time
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Time and Mood Emoji
            HStack {
                Text(timeFormatter.string(from: entry.date)) // Only show time
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(entry.moodEmoji)
                    .font(.title2)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            
            // Journal Text
            Text(entry.text)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.primary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color(hex: "F5F5F5")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        )
    }
}
