import SwiftUI

struct JournalEntryView: View {
    @ObservedObject var viewModel: JournalEntryViewModel
    @Binding var isPresented: Bool
    
    @State private var moodScore: Float = 3.0
    @State private var showJournalEditor = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Title
            Text("How are you feeling today?")
                .font(.title2)
                .fontWeight(.bold)
            
            // Subtitle
            Text("Slide to match your current mood")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // Large emoji display
            Text(moodEmoji(for: moodScore))
                .font(.system(size: 60))
                .padding(.vertical, 16)
            
            // Mood slider
            Slider(value: $moodScore, in: 1...5, step: 1)
                .tint(Color(hex: "8B5DFF"))
                .padding(.horizontal)
            
            // Mood labels
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Text(moodEmoji(for: Float(index)))
                        .font(.system(size: 20))
                        .opacity(abs(Float(index) - moodScore) < 0.5 ? 1 : 0.3)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Continue button
            Button(action: {
                showJournalEditor = true
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "8B5DFF"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
        .sheet(isPresented: $showJournalEditor) {
            JournalEditorView(
                viewModel: viewModel,
                isPresented: $isPresented,
                moodScore: moodScore,
                selectedMoodEmoji: moodEmoji(for: moodScore)
                )
        }
    }
    
    private func moodEmoji(for score: Float) -> String {
        switch score {
        case 1: return "😢"
        case 2: return "😕"
        case 3: return "😐"
        case 4: return "🙂"
        case 5: return "😊"
        default: return "😐"
        }
    }
}
