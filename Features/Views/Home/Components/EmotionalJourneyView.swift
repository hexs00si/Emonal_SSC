import SwiftUI

struct EmotionalJourneyView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Your Emotional Journey This Week")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                Text("Every moment is a step towards understanding yourself.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                ForEach(viewModel.dailyEmotionalScores, id: \.day) { score in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(score.day)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Text(score.emoji)
                                .font(.system(size: 24))
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", score.score)) / 10")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .navigationTitle("Emotional Journey")
    }
}
