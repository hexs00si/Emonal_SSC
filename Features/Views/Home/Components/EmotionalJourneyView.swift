import SwiftUI

struct EmotionalJourneyView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Back Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(Color(hex: "8B5DFF"))
                        .font(.system(size: 17, weight: .regular))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Score Header
                ScoreHeaderView(
                    score: viewModel.weeklyEmotionalScore,
                    weeklyChangeText: viewModel.weeklyChangeText
                )
                
                // Emotional Journey Section
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Emotional Journey")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        ForEach(viewModel.dailyEmotionalScores, id: \.day) { score in
                            DailyScoreRow(day: score.day, score: score.score)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Insight Section
                VStack(spacing: 16) {
                    Text("What This Week Says About You")
                        .font(.headline)
                    
                    Text(getInsightMessage(for: viewModel.weeklyEmotionalScore))
                        .font(.body)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "8B5DFF"),
                                    Color(hex: "5D8BFF")
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
    }
    
    private func getInsightMessage(for score: Float) -> String {
        switch score {
        case 0..<4:
            return "Every emotion is valid. This week might have been challenging, and that's okay. Take gentle care of yourself."
        case 4..<7:
            return "You're navigating your journey thoughtfully. Each day brings new opportunities for growth and self-discovery."
        case 7...10:
            return "Your emotional awareness is flourishing. Remember, it's okay to have ups and downs within these positive moments."
        default:
            return "Your journey is unique. Each entry helps you understand yourself better."
        }
    }
}
