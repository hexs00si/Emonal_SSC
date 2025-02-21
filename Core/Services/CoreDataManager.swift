import CoreData
import SwiftUI

@MainActor
class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()
        
        // Define the JournalEntry entity
        let entity = NSEntityDescription()
        entity.name = "JournalEntry"
        entity.managedObjectClassName = "JournalEntry"
        
        // Add attributes
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.attributeType = .UUIDAttributeType
        idAttribute.isOptional = false
        
        let dateAttribute = NSAttributeDescription()
        dateAttribute.name = "date"
        dateAttribute.attributeType = .dateAttributeType
        dateAttribute.isOptional = false
        
        let textAttribute = NSAttributeDescription()
        textAttribute.name = "text"
        textAttribute.attributeType = .stringAttributeType
        textAttribute.isOptional = false
        
        let moodScoreAttribute = NSAttributeDescription()
        moodScoreAttribute.name = "moodScore"
        moodScoreAttribute.attributeType = .floatAttributeType
        moodScoreAttribute.isOptional = false
        
        let sentimentScoreAttribute = NSAttributeDescription()
        sentimentScoreAttribute.name = "sentimentScore"
        sentimentScoreAttribute.attributeType = .floatAttributeType
        sentimentScoreAttribute.isOptional = true
        sentimentScoreAttribute.defaultValue = 0.0
        
        let moodEmojiAttribute = NSAttributeDescription()
        moodEmojiAttribute.name = "moodEmoji"
        moodEmojiAttribute.attributeType = .stringAttributeType
        moodEmojiAttribute.isOptional = true
        moodEmojiAttribute.defaultValue = "😐"
        
        entity.properties = [
            idAttribute,
            dateAttribute,
            textAttribute,
            moodScoreAttribute,
            sentimentScoreAttribute,
            moodEmojiAttribute
        ]
        
        model.entities = [entity]
        
        let container = NSPersistentContainer(name: "EmonalModel", managedObjectModel: model)
        
        let description = NSPersistentStoreDescription()
        let storeURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("EmonalModel.sqlite")
        
        description.url = storeURL
        description.type = NSSQLiteStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error loading persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
}
