import SwiftUI

struct DailyScoreRow: View {
    let day: String
    let score: Float
    
    var body: some View {
        HStack(spacing: 12) {
            Text(day)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "8B5DFF").opacity(Double(score)/10.0),
                        Color(hex: "5D8BFF").opacity(Double(score)/10.0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(width: CGFloat(score * 20), height: 12)
            
            Spacer()
            
            Text(String(format: "%.1f", score))
                .font(.system(size: 16, weight: .semibold))
        }
    }
}
