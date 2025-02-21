import CoreData
import SwiftUI

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var totalEntries: Int = 0
    @Published var dayStreak: Int = 0
    @Published var streakMessage: String = "Keep going! You're on a streak!"
    @Published var averageMoodScores: [Date: String] = [:] // Date -> Average Mood Emoji
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchEntries()
        calculateStreak()
        calculateAverageMoodScores()
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
    
    func calculateAverageMoodScores() {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JournalEntry.date, ascending: false)]
        
        do {
            let entries = try viewContext.fetch(request)
            var moodScoresByDate: [Date: [Float]] = [:]
            
            // Group entries by date
            for entry in entries {
                let entryDate = Calendar.current.startOfDay(for: entry.date)
                if moodScoresByDate[entryDate] == nil {
                    moodScoresByDate[entryDate] = []
                }
                moodScoresByDate[entryDate]?.append(entry.moodScore)
            }
            
            // Calculate average mood score for each date
            for (date, scores) in moodScoresByDate {
                let averageScore = scores.reduce(0, +) / Float(scores.count)
                averageMoodScores[date] = moodEmoji(for: averageScore)
            }
        } catch {
            print("Error calculating average mood scores: \(error.localizedDescription)")
        }
    }
    
    func fetchEntries(for date: Date) -> [JournalEntry] {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [Calendar.current.startOfDay(for: date), Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: date))!])
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching entries for date: \(error.localizedDescription)")
            return []
        }
    }
    
    private func moodEmoji(for score: Float) -> String {
        switch score {
        case 1..<2: return "😢"
        case 2..<3: return "😕"
        case 3..<4: return "😐"
        case 4..<5: return "🙂"
        case 5...: return "😊"
        default: return "😐"
        }
    }
}
