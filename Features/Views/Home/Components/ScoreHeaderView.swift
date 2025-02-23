import SwiftUI

// Helper View for Score Display
struct ScoreHeaderView: View {
    let score: Float
    let weeklyChangeText: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Weekly Emotional Score")
                .font(.system(size: 28, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text("A gentle reflection of your journal entries this week")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 4) {
                Text("\(String(format: "%.1f", score))")
                    .font(.system(size: 48, weight: .bold))
                Text("/ 10")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.top, 8)
            }
            
            if !weeklyChangeText.contains("nan") {
                HStack(spacing: 6) {
                    Image(systemName: weeklyChangeText.contains("↑") ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .foregroundColor(weeklyChangeText.contains("↑") ?
                            Color(hex: "8B5DFF") : Color(hex: "F3696E"))
                    
                    Text(weeklyChangeText.replacingOccurrences(of: "↑", with: "").replacingOccurrences(of: "↓", with: ""))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.top)
    }
}
