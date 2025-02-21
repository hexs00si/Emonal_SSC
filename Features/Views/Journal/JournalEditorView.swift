import SwiftUI

struct JournalEditorView: View {
    @ObservedObject var viewModel: JournalEntryViewModel
    @Binding var isPresented: Bool
    
    @State private var journalText = ""
    let moodScore: Float
    let selectedMoodEmoji: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Top Bar with Cancel Button
            HStack {
                Spacer()
                Button(action: {
                    isPresented = false // Dismiss the sheet
                }) {
                    Text("Cancel")
                        .foregroundColor(.black) // Black color for minimalism
                        .font(.headline)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            // Title and Date
            VStack(spacing: 8) {
                Text("What's on your mind?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(Date(), formatter: dateFormatter)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            // Journal Text Editor
            TextEditor(text: $journalText)
                .frame(maxHeight: .infinity)
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .overlay(
                    Group {
                        if journalText.isEmpty {
                            Text("Start writing...")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 32)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        }
                    }
                )
                .padding(.horizontal)
            
            // Save Button
            Button(action: saveAndDismiss) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "8B5DFF"))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .disabled(journalText.isEmpty)
            .opacity(journalText.isEmpty ? 0.6 : 1.0)
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
    }
    
    private func saveAndDismiss() {
        // Save journal entry
        viewModel.saveEntry(
            text: journalText,
            moodScore: moodScore,
            moodEmoji: selectedMoodEmoji
        )
        
        // Dismiss all sheets
        isPresented = false
    }
    
    // Custom date formatter
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }
}
