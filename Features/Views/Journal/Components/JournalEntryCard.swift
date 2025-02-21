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
            HStack {
                Text(dateFormatter.string(from: entry.date))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(entry.text)
                .font(.body)
                .lineLimit(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .overlay(
            Text(entry.moodEmoji)
                .font(.title)
                .padding(8)
                .background(Color.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                .offset(x: -8, y: -8),
            alignment: .topTrailing
        )
    }
}
