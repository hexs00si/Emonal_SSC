import SwiftUI

struct JournalEditorView: View {
    @ObservedObject var viewModel: JournalEntryViewModel
    @Binding var isPresented: Bool
    
    @State private var journalText = ""
    let moodScore: Float
    let selectedMoodEmoji: String
    
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
            
            // Date Display
            Text(Date(), formatter: dateFormatter)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("What's on your mind?")
                .font(.title2)
                .fontWeight(.bold)
            
            // Journal Text Editor
            TextEditor(text: $journalText)
                .frame(minHeight: 200)
                .overlay(
                    Group {
                        if journalText.isEmpty {
                            Text("Start writing...")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 12)
                        }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .padding()
            
            Spacer()
            
            // Save Button
            Button(action: {
                // Save journal entry
                viewModel.saveEntry(
                    text: journalText,
                    moodScore: moodScore,
                    moodEmoji: selectedMoodEmoji
                )
                
                // Dismiss all sheets
                isPresented = false
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "8B5DFF"))
                    .cornerRadius(10)
            }
            .padding()
            .disabled(journalText.isEmpty)
        }
    }
    
    // Custom date formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
}

