import SwiftUI

struct GreetingView: View {
    @State private var timeOfDay = getCurrentTimeOfDay()
    @State private var greetingEmoji = getTimeOfDayEmoji()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good \(timeOfDay)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Emoji without animation
            Text(greetingEmoji)
                .font(.system(size: 36))
        }
        .padding(.horizontal)
    }
    
    // Helper function to get current time of day
    static func getCurrentTimeOfDay() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<22: return "Evening"
        default: return "Night"
        }
    }
    
    // Helper function to get appropriate emoji
    static func getTimeOfDayEmoji() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "🌅"
        case 12..<17: return "☀️"
        case 17..<22: return "🌇"
        default: return "🌙"
        }
    }
}
