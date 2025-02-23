import SwiftUI

struct Quote: Identifiable, Sendable {
    let id = UUID()
    let text: String
    let source: String
    let chapter: String
}

@MainActor
class QuoteManager: ObservableObject {
    static let shared: QuoteManager = {
        let instance = QuoteManager()
        return instance
    }()
    
    private init() {} // Private initializer for singleton
    
    // Get quote based on emotional score (0-10 range)
    func getQuoteForScore(_ score: Float) -> Quote {
        // Using the same ranges as your moodEmoji function for consistency
        switch score {
        case 0..<2:
            return quotes.veryLow.randomElement() ?? defaultQuote
        case 2..<4:
            return quotes.low.randomElement() ?? defaultQuote
        case 4..<6:
            return quotes.moderate.randomElement() ?? defaultQuote
        case 6..<8:
            return quotes.good.randomElement() ?? defaultQuote
        case 8...10:
            return quotes.excellent.randomElement() ?? defaultQuote
        default:
            return defaultQuote
        }
    }
    
    private let defaultQuote = Quote(
        text: "The journey of self-discovery is the most important journey of all.",
        source: "Bhagavad Gita",
        chapter: "2.28"
    )
    
    private let quotes = (
        veryLow: [
            Quote(
                text: "Delusion arises from anger. The mind is bewildered by delusion. Reasoning is destroyed when the mind is bewildered. One falls down when reasoning is destroyed.",
                source: "Bhagavad Gita",
                chapter: "2.63"
            ),
            // Add more quotes for very low scores
        ],
        low: [
            Quote(
                text: "It is better to live your own destiny imperfectly than to live an imitation of somebody else's life with perfection.",
                source: "Bhagavad Gita",
                chapter: "3.35"
            ),
            // Add more quotes for low scores
        ],
        moderate: [
            Quote(
                text: "You have the right to work, but never to the fruit of work. You should never engage in action for the sake of reward.",
                source: "Bhagavad Gita",
                chapter: "2.47"
            ),
            // Add more quotes for moderate scores
        ],
        good: [
            Quote(
                text: "The happiness which comes from long practice, which leads to the end of suffering, such happiness arises from the serenity of one's own mind.",
                source: "Bhagavad Gita",
                chapter: "18.37"
            ),
            // Add more quotes for good scores
        ],
        excellent: [
            Quote(
                text: "When meditation is mastered, the mind is unwavering like the flame of a lamp in a windless place.",
                source: "Bhagavad Gita",
                chapter: "6.19"
            ),
            // Add more quotes for excellent scores
        ]
    )
}
