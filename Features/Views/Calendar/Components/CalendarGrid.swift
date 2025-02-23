import SwiftUI

struct CalendarGrid: View {
    @Binding var selectedDate: Date?
    let averageMoodScores: [Date: String]
    
    var body: some View {
        VStack(spacing: 16) {
            // Month and Year header remains the same
            Text(selectedDate?.formatted(.dateTime.month(.wide).year()) ?? Date().formatted(.dateTime.month(.wide).year()))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 8)
            
            // Weekday headers remain the same
            let weekdays = ["S", "M", "T", "W", "T", "F", "S"]
            HStack {
                ForEach(weekdays.indices, id: \.self) { index in
                    Text(weekdays[index])
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Modified Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(getDaysInMonth(for: selectedDate ?? Date()), id: \.id) { dayInfo in
                    if let date = dayInfo.date {
                        CalendarCell(date: date,
                                   moodEmoji: averageMoodScores[date],
                                   isSelected: selectedDate == date,
                                   hasEntries: averageMoodScores[date] != nil)
                            .onTapGesture {
                                if averageMoodScores[date] != nil {
                                    selectedDate = date
                                }
                            }
                    } else {
                        Color.clear
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
    
    // Helper struct to provide unique IDs
    private struct DayInfo: Identifiable {
        let id: String
        let date: Date?
        
        init(date: Date?, index: Int) {
            self.date = date
            self.id = "\(index)-\(date?.description ?? "empty")"
        }
    }
    
    private func getDaysInMonth(for date: Date) -> [DayInfo] {
        let calendar = Calendar.current
        
        // Get start of the month
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth)
        else { return [] }
        
        // Get the weekday of the first day (1-7, 1 is Sunday)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        // Create array with leading nil values for padding
        var days: [DayInfo] = []
        
        // Add leading empty days
        for i in 0..<(firstWeekday - 1) {
            days.append(DayInfo(date: nil, index: i))
        }
        
        // Add all days of the month
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(DayInfo(date: date, index: days.count))
            }
        }
        
        // Add trailing empty days to complete the last week
        let remainingDays = (7 - (days.count % 7)) % 7
        for i in 0..<remainingDays {
            days.append(DayInfo(date: nil, index: days.count + i))
        }
        
        return days
    }
}
