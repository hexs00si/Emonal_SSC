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
            Quote(text: "Delusion arises from anger. The mind is bewildered by delusion. Reasoning is destroyed when the mind is bewildered. One falls down when reasoning is destroyed.", source: "Bhagavad Gita", chapter: "2.63"),
            Quote(text: "The mind acts like an enemy for those who do not control it.", source: "Bhagavad Gita", chapter: "6.6"),
            Quote(text: "Hell has three gates: lust, anger, and greed. Every sane man should give these up, for they lead to the degradation of the soul.", source: "Bhagavad Gita", chapter: "16.21"),
            Quote(text: "A person who is not disturbed by distress and is free from fear and anger is called a sage of steady mind.", source: "Bhagavad Gita", chapter: "2.56"),
            Quote(text: "The wise do not grieve for the dead or the living.", source: "Bhagavad Gita", chapter: "2.11")
        ],
        low: [
            Quote(text: "It is better to live your own destiny imperfectly than to live an imitation of somebody else's life with perfection.", source: "Bhagavad Gita", chapter: "3.35"),
            Quote(text: "For one who has conquered the mind, the mind is the best of friends; but for one who has failed to do so, his mind will remain the greatest enemy.", source: "Bhagavad Gita", chapter: "6.6"),
            Quote(text: "A person can rise through the efforts of his own mind; or in the same manner, draw himself down. Because each person is his own friend or enemy.", source: "Bhagavad Gita", chapter: "6.5"),
            Quote(text: "The soul is neither born, nor does it ever die; nor having once existed, does it cease to be.", source: "Bhagavad Gita", chapter: "2.20"),
            Quote(text: "Work done with selfish motives is inferior by far to the selfless work done without attachment.", source: "Bhagavad Gita", chapter: "2.49")
        ],
        moderate: [
            Quote(text: "You have the right to work, but never to the fruit of work. You should never engage in action for the sake of reward.", source: "Bhagavad Gita", chapter: "2.47"),
            Quote(text: "One who is not disturbed by happiness and distress, and is steady in both, is certainly eligible for liberation.", source: "Bhagavad Gita", chapter: "2.15"),
            Quote(text: "Those who are wise see that there is no difference between a learned and gentle Brahman, a cow, an elephant, a dog, and a dog-eater.", source: "Bhagavad Gita", chapter: "5.18"),
            Quote(text: "As the heat of a fire reduces wood to ashes, the fire of knowledge burns to ashes all karma.", source: "Bhagavad Gita", chapter: "4.37"),
            Quote(text: "Neither in this world nor elsewhere is there any happiness for one who doubts.", source: "Bhagavad Gita", chapter: "4.40")
        ],
        good: [
            Quote(text: "The happiness which comes from long practice, which leads to the end of suffering, such happiness arises from the serenity of one's own mind.", source: "Bhagavad Gita", chapter: "18.37"),
            Quote(text: "There is neither this world nor the world beyond nor happiness for the one who doubts.", source: "Bhagavad Gita", chapter: "4.40"),
            Quote(text: "He who sees inaction in action and action in inaction is truly wise among men.", source: "Bhagavad Gita", chapter: "4.18"),
            Quote(text: "The one who is free from attachments, who neither rejoices on obtaining good nor laments on receiving evil, is firmly fixed in perfect knowledge.", source: "Bhagavad Gita", chapter: "2.57"),
            Quote(text: "A truly wise person remains balanced in joy and sorrow, gain and loss, success and failure.", source: "Bhagavad Gita", chapter: "2.38")
        ],
        excellent: [
            Quote(text: "When meditation is mastered, the mind is unwavering like the flame of a lamp in a windless place.", source: "Bhagavad Gita", chapter: "6.19"),
            Quote(text: "The soul is neither born, and nor does it die. It is eternal and indestructible.", source: "Bhagavad Gita", chapter: "2.20"),
            Quote(text: "A person who is not disturbed by the incessant flow of desires can alone achieve peace, and not the one who strives to satisfy such desires.", source: "Bhagavad Gita", chapter: "2.70"),
            Quote(text: "The yogi who is content with knowledge and wisdom, who is unshaken, who has conquered his senses, is said to be steadfast.", source: "Bhagavad Gita", chapter: "6.8"),
            Quote(text: "With a disciplined mind, you can go beyond the reach of desires and fears and achieve inner peace.", source: "Bhagavad Gita", chapter: "6.7")
        ]
    )
}
