import SwiftUI

struct DailyScoreRow: View {
    let day: String
    let score: Float
    
    var body: some View {
        HStack(spacing: 12) {
            // Day label
            Text(day)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
                .lineLimit(1)
            
            // Progress bar container with fixed width
            GeometryReader { geometry in
                RoundedRectangle(cornerRadius: 6)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "8B5DFF").opacity(Double(score)/10.0),
                            Color(hex: "5D8BFF").opacity(Double(score)/10.0)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(width: geometry.size.width * CGFloat(score/10), height: 12)
            }
            .frame(height: 12)
            
            // Score
            Text(String(format: "%.1f", score))
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 35, alignment: .trailing)
                .lineLimit(1)
        }
        .frame(height: 20)
    }
}
