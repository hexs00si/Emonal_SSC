import SwiftUI

struct JournalEntryView: View {
    @ObservedObject var viewModel: JournalEntryViewModel
    @Binding var isPresented: Bool
    
    @State private var selectedMood: Double = 2 // Middle mood
    @State private var selectedMoodEmoji: String = "😐"
    @State private var isNextStep = false
    
    // Mood configuration
    let moods = [
        (emoji: "😢", label: "Very Sad", value: 0.0),
        (emoji: "🙁", label: "Sad", value: 1.0),
        (emoji: "😐", label: "Neutral", value: 2.0),
        (emoji: "🙂", label: "Happy", value: 3.0),
        (emoji: "😄", label: "Very Happy", value: 4.0)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Navigation Bar
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.gray)
                }
                Spacer()
            }
            .padding()
            
            // Title
            Text("How are you feeling today?")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Slide to match your current mood")
                .foregroundColor(.secondary)
            
            // Large Mood Emoji
            Text(selectedMoodEmoji)
                .font(.system(size: 80))
                .padding()
            
            // Mood Emojis
            HStack(spacing: 0) {
                ForEach(moods, id: \.label) { mood in
                    Text(mood.emoji)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Custom Discrete Slider
            CustomDiscreteSlider(
                value: $selectedMood,
                steps: Double(moods.count - 1)
            )
            .onChange(of: selectedMood) { newValue in
                // Round to nearest integer to get the correct mood
                let index = Int(round(newValue))
                selectedMoodEmoji = moods[index].emoji
            }
            
            // Mood Label
            Text(moods[Int(round(selectedMood))].label)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                isNextStep = true
            }) {
                Text("Continue")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "8B5DFF"))
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isNextStep) {
            JournalEditorView(
                viewModel: viewModel,
                isPresented: $isPresented,
                moodScore: Float(selectedMood / Double(moods.count - 1)),
                selectedMoodEmoji: selectedMoodEmoji
            )
        }
    }
}
// (Keep the CustomDiscreteSlider from the previous implementation)
struct CustomDiscreteSlider: View {
    @Binding var value: Double
    let steps: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Track
                Rectangle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(height: 5)
                    .cornerRadius(2.5)
                
                // Filled Track
                Rectangle()
                    .fill(Color(hex: "8B5DFF"))
                    .frame(width: CGFloat(value / steps) * geometry.size.width, height: 5)
                    .cornerRadius(2.5)
                
                // Slider Thumb
                Circle()
                    .fill(Color(hex: "8B5DFF"))
                    .frame(width: 20, height: 20)
                    .offset(x: CGFloat(value / steps) * geometry.size.width - 10)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                // Calculate the new value based on the drag position
                                let newValue = min(max(0, gesture.translation.width / geometry.size.width * steps + value), steps)
                                // Snap to nearest step
                                self.value = round(newValue)
                            }
                    )
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
    }
}
