import CoreData
import SwiftUI

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var totalEntries: Int = 0
    @Published var dayStreak: Int = 0
    @Published var streakMessage: String = "Keep going! You're on a streak!"
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchEntries()
        calculateStreak()
    }
    
    func fetchEntries() {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        do {
            let entries = try viewContext.fetch(request)
            totalEntries = entries.count
        } catch {
            print("Error fetching entries: \(error.localizedDescription)")
        }
    }
    
    func calculateStreak() {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JournalEntry.date, ascending: false)]
        
        do {
            let entries = try viewContext.fetch(request)
            guard !entries.isEmpty else {
                dayStreak = 0
                streakMessage = "Start your journaling streak today!"
                return
            }
            
            var streak = 0
            var previousDate = Calendar.current.startOfDay(for: Date())
            
            for entry in entries {
                let entryDate = Calendar.current.startOfDay(for: entry.date)
                if entryDate == previousDate {
                    continue // Same day, skip
                } else if Calendar.current.date(byAdding: .day, value: -1, to: previousDate) == entryDate {
                    streak += 1
                    previousDate = entryDate
                } else {
                    break // Streak broken
                }
            }
            
            dayStreak = streak
            if streak == 0 {
                streakMessage = "Start your journaling streak today!"
            } else if streak < 3 {
                streakMessage = "Keep going! You're on a streak!"
            } else {
                streakMessage = "Amazing! You're on a \(streak)-day streak!"
            }
        } catch {
            print("Error calculating streak: \(error.localizedDescription)")
        }
    }
}
