import CoreData
import SwiftUI

@MainActor
class JournalEntryViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    
    @Published var entries: [JournalEntry] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchEntries()
    }
    
    func fetchEntries() {
        let request: NSFetchRequest<JournalEntry> = JournalEntry.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JournalEntry.date, ascending: false)]
        
        do {
            entries = try viewContext.fetch(request)
        } catch {
            print("Error fetching entries: \(error.localizedDescription)")
            entries = []
        }
    }
    
    func saveEntry(text: String, moodScore: Float, moodEmoji: String) {
        let entry = JournalEntry(context: viewContext)
        entry.text = text
        entry.moodScore = moodScore
        entry.moodEmoji = moodEmoji
        
        do {
            try viewContext.save()
            fetchEntries()
            print("Entry saved successfully")
        } catch {
            print("Error saving entry: \(error.localizedDescription)")
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        viewContext.delete(entry)
        
        do {
            try viewContext.save()
            fetchEntries()
        } catch {
            print("Error deleting entry: \(error.localizedDescription)")
        }
    }
}
