import CoreData
import Foundation

@objc(JournalEntry)
public class JournalEntry: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var date: Date
    @NSManaged public var text: String
    @NSManaged public var moodScore: Float
    @NSManaged public var sentimentScore: Float
    @NSManaged public var moodEmoji: String
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.id = UUID()
        self.date = Date()
        self.sentimentScore = 0.0
        self.moodEmoji = "😐"
    }
}

extension JournalEntry {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JournalEntry> {
        return NSFetchRequest<JournalEntry>(entityName: "JournalEntry")
    }
}
