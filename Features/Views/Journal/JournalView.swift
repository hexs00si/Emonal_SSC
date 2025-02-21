import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel: JournalEntryViewModel
    @State private var showJournalEntry = false
    
    init() {
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: JournalEntryViewModel(viewContext: context))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                Text("Your Journal")
                    .font(.title)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {
                    showJournalEntry = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color(hex: "8B5DFF"))
                        .clipShape(Circle())
                }
            }
            .padding()
            
            WaveHeaderView()
                .padding(.bottom, 16)
            
            if viewModel.entries.isEmpty {
                EmptyJournalView()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.entries) { entry in
                            JournalEntryCard(entry: entry, viewModel: viewModel)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .sheet(isPresented: $showJournalEntry) {
            JournalEntryView(viewModel: viewModel, isPresented: $showJournalEntry)
        }
    }
}
