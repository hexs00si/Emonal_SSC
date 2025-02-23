import SwiftUI

struct EmotionalJourneyView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Custom Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purple)
                        Text("Back")
                            .foregroundColor(.purple)
                            .font(.body)
                    }
                }
                Spacer()
            }
            .padding(.leading)

            // Emotional Score Display
            VStack(spacing: 8) {
                Text("Your Weekly Emotional Score")
                    .font(.title)
                    .fontWeight(.bold)

                HStack {
                    Text("\(String(format: "%.1f", viewModel.weeklyEmotionalScore))")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.primary)

                    Text("/ 10")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }

                if !viewModel.weeklyChangeText.contains("nan") {
                    HStack {
                        Image(systemName: viewModel.weeklyChangeText.contains("↑") ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundColor(viewModel.weeklyChangeText.contains("↑") ? .green : .red)

                        Text(viewModel.weeklyChangeText.replacingOccurrences(of: "↑", with: "").replacingOccurrences(of: "↓", with: ""))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Emotional Journey - Linear Calendar
            VStack(spacing: 16) {
                Text("Your Emotional Journey")
                    .font(.title2)
                    .fontWeight(.bold)
                
                VStack(spacing: 12) {
                    ForEach(viewModel.dailyEmotionalScores, id: \.day) { score in
                        HStack {
                            Text(score.day) // Full day name
                                .font(.headline)
                                .frame(width: 60, alignment: .leading)
                                .foregroundColor(.secondary)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(emotionColor(for: score.score))
                                .frame(width: CGFloat(score.score * 20), height: 10)

                            Spacer()
                            
                            Text("\(String(format: "%.1f", score.score))")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                }
                .padding(.horizontal)
            }

            // Insight Section
            VStack(spacing: 8) {
                Text("What This Week Says About You")
                    .font(.headline)

                Text(getInsightMessage(for: viewModel.weeklyEmotionalScore))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }

    private func emotionColor(for score: Float) -> Color {
        switch score {
        case 0..<4: return .red
        case 4..<7: return .yellow
        case 7...10: return .green
        default: return .gray
        }
    }

    private func getInsightMessage(for score: Float) -> String {
        switch score {
        case 0..<4:
            return "It’s okay to have tough weeks. Take some time for self-care and reflection."
        case 4..<7:
            return "You're making progress! Keep celebrating small wins."
        case 7...10:
            return "Amazing! Keep up the positive momentum!"
        default:
            return "Reflect on your emotions and celebrate your journey."
        }
    }
}
