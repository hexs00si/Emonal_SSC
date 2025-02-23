import SwiftUI
import CoreData
import NaturalLanguage

class HomeViewModel: ObservableObject {
    @Published var weeklyEmotionalScore: Float = 0
    @Published var weeklyChangeText: String = ""
    @Published var weeklyChangeColor: Color = .primary
    @Published var dailyEmotionalScores: [DailyEmotionalScore] = []
    
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        calculateWeeklyEmotionalScore()
    }
    
    private func calculateWeeklyEmotionalScore() {
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfWeek)!
        
        let entries = fetchEntries(from: startOfWeek, to: endOfWeek)
        guard !entries.isEmpty else {
            weeklyEmotionalScore = 0
            weeklyChangeText = "0.0"
            weeklyChangeColor = .primary
            dailyEmotionalScores = []
            return
        }

        let scores = entries.map { entry in
            let sentimentScore = calculateSentimentScore(for: entry.text)
            return calculateEmotionalScore(moodScore: entry.moodScore, sentimentScore: sentimentScore)
        }

        let totalScore = scores.reduce(0, +)
        weeklyEmotionalScore = totalScore / Float(scores.count)
        
        // Calculate weekly change
        let lastWeekScore = calculateLastWeekEmotionalScore()
        let change = weeklyEmotionalScore - lastWeekScore
        weeklyChangeText = String(format: "%.1f", abs(change)) + (change >= 0 ? "↑" : "↓")
        weeklyChangeColor = change >= 0 ? .green : .red
        
        // Calculate daily emotional scores
        let groupedEntries = Dictionary(grouping: entries, by: { Calendar.current.startOfDay(for: $0.date) })
        dailyEmotionalScores = groupedEntries.map { date, entries in
            let scores = entries.map { entry in
                let sentimentScore = calculateSentimentScore(for: entry.text)
                return calculateEmotionalScore(moodScore: entry.moodScore, sentimentScore: sentimentScore)
            }
            let averageScore = scores.reduce(0, +) / Float(scores.count)
            return DailyEmotionalScore(day: date.formatted(.dateTime.weekday(.wide)), emoji: moodEmoji(for: averageScore), score: averageScore)
        }
        
        // Sort the days from Monday to Sunday
        let dayOrder = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        dailyEmotionalScores.sort { dayOrder.firstIndex(of: $0.day)! < dayOrder.firstIndex(of: $1.day)! }
    }
    
    private func calculateLastWeekEmotionalScore() -> Float {
        let startOfLastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!)!
        let endOfLastWeek = Calendar.current.date(byAdding: .day, value: 7, to: startOfLastWeek)!
        
        let lastWeekEntries = fetchEntries(from: startOfLastWeek, to: endOfLastWeek)
        guard !lastWeekEntries.isEmpty else {
            return 0
        }

        let scores = lastWeekEntries.map { entry in
            let sentimentScore = calculateSentimentScore(for: entry.text)
            return calculateEmotionalScore(moodScore: entry.moodScore, sentimentScore: sentimentScore)
        }
        return scores.reduce(0, +) / Float(scores.count)
    }
    
    private func calculateSentimentScore(for text: String) -> Float {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return Float(sentiment?.rawValue ?? "0") ?? 0
    }
    
    private func calculateEmotionalScore(moodScore: Float, sentimentScore: Float) -> Float {
        // Normalize mood score to 0-1 range (1-5 becomes 0-1)
        let normalizedMood = (moodScore - 1) / 4
        
        // Normalize sentiment score to 0-1 range (-1 to 1 becomes 0-1)
        let normalizedSentiment = (sentimentScore + 1) / 2
        
        // Combine mood score (weighted 55%) and sentiment score (weighted 45%)
        let emotionalScore = (normalizedMood * 0.55) + (normalizedSentiment * 0.45)
        
        // Scale to 0-10 range
        return emotionalScore * 10
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
    
    // Fetch entries for a specific date range
    func fetchEntries(from startDate: Date, to endDate: Date) -> [JournalEntry] {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [startDate, endDate])
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching entries for date range: \(error.localizedDescription)")
            return []
        }
    }
}

struct DailyEmotionalScore {
    let day: String
    let emoji: String
    let score: Float
}
