import SwiftUI

struct CalendarCell: View {
    let date: Date
    let moodEmoji: String?
    let isSelected: Bool
    let hasEntries: Bool // Indicates whether the date has entries
    
    var body: some View {
        VStack(spacing: 4) {
            if let moodEmoji = moodEmoji {
                // Replace the date with the mood emoji if there are entries
                Text(moodEmoji)
                    .font(.title3)
            } else {
                // Show the date number if there are no entries
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isSelected ? Color(hex: "8B5DFF").opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .opacity(hasEntries ? 1 : 0.5) // Dim dates with no entries
    }
}
