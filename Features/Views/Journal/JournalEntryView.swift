import SwiftUI

struct JournalEntryView: View {
    @ObservedObject var viewModel: JournalEntryViewModel
    @Binding var isPresented: Bool
    @State private var journalText = ""
    @State private var moodScore: Float = 3.0
    @State private var selectedEmoji = "😐"
    @State private var textEditorHeight: CGFloat = 200
    @State private var isTyping = false  // Track if user is typing

    let moodOptions = [
        ("😢", 1.0),
        ("😕", 2.0),
        ("😐", 3.0),
        ("🙂", 4.0),
        ("😊", 5.0)
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Mood Selection
                VStack(spacing: 16) {
                    Text("How are you feeling?")
                        .font(.title3)
                        .fontWeight(.medium)

                    HStack(spacing: 24) {
                        ForEach(moodOptions, id: \.0) { emoji, score in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedEmoji = emoji
                                    moodScore = Float(score)
                                }
                            }) {
                                Text(emoji)
                                    .font(.system(size: 32))
                                    .padding(12)
                                    .background(
                                        Circle()
                                            .fill(selectedEmoji == emoji ?
                                                Color(hex: "8B5DFF").opacity(0.3) :
                                                Color.clear)
                                            .animation(.spring(response: 0.3), value: selectedEmoji)
                                    )
                                    .scaleEffect(selectedEmoji == emoji ? 1.1 : 1.0)
                            }
                        }
                    }
                }
                .padding(.top, 8)

                // Text Editor with Placeholder
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "F5F5F5"))
                        .shadow(color: Color.black.opacity(0.05), radius: 10, y: 5)
                        .frame(height: max(200, textEditorHeight))

                    if journalText.isEmpty && !isTyping {
                        Text("Write about your day...")
                            .foregroundColor(.gray)
                            .padding(16)
                    }

                    TextEditor(text: $journalText)
                        .frame(height: max(200, textEditorHeight))
                        .padding(12)
                        .opacity(journalText.isEmpty ? 0.7 : 1)  // Fade effect
                        .onTapGesture {
                            isTyping = true
                        }
                }

                Spacer()
            }
            .padding()
            .navigationBarItems(
                leading: Button("Cancel") {
                    withAnimation {
                        isPresented = false
                    }
                }
                .foregroundColor(Color(hex: "8B5DFF"))
                .fontWeight(.medium),
                
                trailing: Button("Save") {
                    withAnimation {
                        viewModel.saveEntry(
                            text: journalText,
                            moodScore: moodScore,
                            moodEmoji: selectedEmoji
                        )
                        isPresented = false
                    }
                }
                .foregroundColor(Color(hex: "8B5DFF"))
                .fontWeight(.medium)
                .disabled(journalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            )
            .navigationBarTitle("New Entry", displayMode: .inline)
        }
    }
}
