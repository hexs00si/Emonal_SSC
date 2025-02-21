import CoreData
import SwiftUI

@MainActor
class JournalEntryViewModel: ObservableObject {
    let viewContext: NSManagedObjectContext
    @Published private(set) var entries: [EntryData] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchEntries()
    }
    
    // Safe data structure for entries
    struct EntryData: Identifiable {
        let id: UUID
        let date: Date
        let text: String
        let moodScore: Float
        let moodEmoji: String
        let originalEntry: JournalEntry
        
        init(from entry: JournalEntry) {
            self.id = entry.id
            self.date = entry.date
            self.text = entry.text
            self.moodScore = entry.moodScore
            self.moodEmoji = entry.moodEmoji
            self.originalEntry = entry
        }
    }
    
    func fetchEntries() {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JournalEntry.date, ascending: false)]
        
        do {
            let fetchedEntries = try viewContext.fetch(request)
            entries = fetchedEntries.map { EntryData(from: $0) }
        } catch {
            print("Error fetching entries: \(error)")
            entries = []
        }
    }
    
    func saveEntry(text: String, moodScore: Float, moodEmoji: String) {
        let entry = JournalEntry(context: viewContext)
        entry.id = UUID()
        entry.date = Date()
        entry.text = text
        entry.moodScore = moodScore
        entry.moodEmoji = moodEmoji
        entry.sentimentScore = 0.0
        
        do {
            try viewContext.save()
            fetchEntries()
        } catch {
            print("Error saving entry: \(error)")
        }
    }
    
    func deleteEntry(_ entry: EntryData) {
        viewContext.delete(entry.originalEntry)
        
        do {
            try viewContext.save()
            entries.removeAll { $0.id == entry.id }
        } catch {
            print("Error deleting entry: \(error)")
            fetchEntries()
        }
    }
}
