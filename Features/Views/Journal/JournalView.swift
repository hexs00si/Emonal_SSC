import SwiftUI
import CoreData

struct JournalView: View {
    @StateObject private var viewModel: JournalEntryViewModel
    @State private var showJournalEntry = false
    
    init() {
        // Use the view context directly from CoreDataManager
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: JournalEntryViewModel(viewContext: context))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar with Title and Plus Button
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
            
            // Wave Header
            WaveHeaderView()
                .padding(.bottom, 16)
            
            // Conditional content based on entries
            if viewModel.entries.isEmpty {
                EmptyJournalView()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.entries, id: \.id) { entry in
                            JournalEntryCard(entry: entry)
                        }
                    }
                    .padding()
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $showJournalEntry) {
            JournalEntryView(viewModel: viewModel, isPresented: $showJournalEntry)
        }
        .onAppear {
            viewModel.fetchEntries()
        }
    }
}
