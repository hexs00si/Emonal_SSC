import SwiftUI

struct CalendarGrid: View {
    @Binding var selectedDate: Date?
    let averageMoodScores: [Date: String]
    
    var body: some View {
        VStack(spacing: 16) {
            // Month and Year
            Text(selectedDate?.formatted(.dateTime.month(.wide).year()) ?? Date().formatted(.dateTime.month(.wide).year()))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            // Weekday Headers
            let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
            HStack {
                ForEach(weekdays.indices, id: \.self) { index in // Use indices for unique IDs
                    Text(weekdays[index])
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(getDaysInMonth(for: selectedDate ?? Date()), id: \.self) { date in
                    CalendarCell(date: date, moodEmoji: averageMoodScores[date], isSelected: selectedDate == date, hasEntries: averageMoodScores[date] != nil)
                        .onTapGesture {
                            // Only allow tap if the date has entries
                            if averageMoodScores[date] != nil {
                                selectedDate = date
                            }
                        }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    private func getDaysInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        
        return (0..<range.count).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth)
        }
    }
}
