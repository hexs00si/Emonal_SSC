import SwiftUI

struct JournalDetailView: View {
    let entry: JournalEntryViewModel.EntryData
    @ObservedObject var viewModel: JournalEntryViewModel
    @Binding var isPresented: Bool
    @State private var showDeleteAlert = false
    @State private var deleteScale: CGFloat = 1
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Date and Time Stack
                VStack(spacing: 4) {
                    Text(dateFormatter.string(from: entry.date))
                        .font(.system(size: 24, weight: .bold))
                    
                    Text(timeFormatter.string(from: entry.date))
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
                
                // Centered Emoji with Background
                Text(entry.moodEmoji)
                    .font(.system(size: 40))
                    .padding(24)
                    .background(
                        Circle()
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, y: 4)
                    )
                    .background(
                        Circle()
                            .fill(Color(hex: "8B5DFF").opacity(0.1))
                            .frame(width: 100, height: 100)
                    )
                    .padding(.vertical, 16)
                
                // Journal Content
                VStack(alignment: .leading, spacing: 16) {
                    Text(entry.text)
                        .font(.body)
                        .lineSpacing(8)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Delete Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        deleteScale = 0.95
                        showDeleteAlert = true
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "trash")
                            .imageScale(.medium)
                        Text("Delete Entry")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.red)
                            .shadow(color: Color.red.opacity(0.3), radius: 8, y: 4)
                    )
                    .padding(.horizontal)
                }
                .scaleEffect(deleteScale)
                .onChange(of: showDeleteAlert) { newValue in
                    if !newValue {
                        withAnimation(.spring(response: 0.3)) {
                            deleteScale = 1
                        }
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Journal Entry", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                withAnimation(.spring(response: 0.3)) {
                    deleteScale = 1
                }
            }
            Button("Delete", role: .destructive) {
                withAnimation {
                    isPresented = false
                    viewModel.deleteEntry(entry)
                }
            }
        } message: {
            Text("Are you sure you want to delete this journal entry? This action cannot be undone.")
        }
    }
}
