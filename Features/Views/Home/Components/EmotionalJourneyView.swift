import SwiftUI

struct EmotionalJourneyView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var dragOffset = CGSize.zero
    @GestureState private var isDragging = false
    
    var body: some View {
        GeometryReader { geometry in
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
                    VStack(spacing: 8) {
                        Text("Your Weekly Emotional Score")
                            .font(.system(size: 32, weight: .bold))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.horizontal, 20)
                        
                        Text("A gentle reflection of your journal entries this week")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                        HStack {
                            Text("\(String(format: "%.1f", viewModel.weeklyEmotionalScore))")
                                .font(.system(size: 48, weight: .bold))
                            Text("/ 10")
                                .font(.title2)
                                .foregroundColor(.secondary)
                                .padding(.top, 8)
                        }
                        
                        if !viewModel.weeklyChangeText.contains("nan") {
                            HStack(spacing: 6) {
                                Image(systemName: viewModel.weeklyChangeText.contains("↑") ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                                    .foregroundColor(viewModel.weeklyChangeText.contains("↑") ?
                                        Color(hex: "8B5DFF") : Color(hex: "F3696E"))
                                
                                Text(viewModel.weeklyChangeText.replacingOccurrences(of: "↑", with: "").replacingOccurrences(of: "↓", with: ""))
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    
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
                    
                    Spacer(minLength: 0)
                }
                .padding(.vertical)
                .frame(minHeight: geometry.size.height)
                .frame(maxWidth: geometry.size.width)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true)
            .offset(x: max(0, dragOffset.width))
            .gesture(
                DragGesture()
                    .updating($isDragging) { value, state, _ in
                        state = true
                    }
                    .onChanged { gesture in
                        if gesture.translation.width > 0 {
                            dragOffset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        let threshold = geometry.size.width * 0.3
                        if gesture.translation.width > threshold {
                            presentationMode.wrappedValue.dismiss()
                        }
                        withAnimation(.interactiveSpring()) {
                            dragOffset = .zero
                        }
                    }
            )
            .animation(isDragging ? .interactiveSpring() : nil, value: dragOffset)
        }
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
