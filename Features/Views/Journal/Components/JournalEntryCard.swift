import SwiftUI

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy 'at' h:mm a"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Date and Mood Emoji
            HStack {
                Text(dateFormatter.string(from: entry.date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(entry.moodEmoji)
                    .font(.title2)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2) // Darker shadow
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
                            Color(hex: "F5F5F5") // Subtle gradient
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Darker and steeper shadow
        )
        .padding(.horizontal, 8)
    }
}
