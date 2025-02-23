import SwiftUI

struct JournalView: View {
    @StateObject private var viewModel: JournalEntryViewModel
    @State private var showJournalEntry = false
    
    init() {
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: JournalEntryViewModel(viewContext: context))
    }
    
    // Helper function to group entries by date
    private var groupedEntries: [(String, [JournalEntryViewModel.EntryData])] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy" // Grouping format (e.g., "22 Feb 2025")

        let grouped = Dictionary(grouping: viewModel.entries) { entry in
            dateFormatter.string(from: entry.date)
        }

        return grouped.sorted { $0.key > $1.key } // Sort by date in descending order
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
                .padding(.bottom, 12)
            
            if viewModel.entries.isEmpty {
                EmptyJournalView()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(groupedEntries, id: \.0) { (date, entries) in
                            VStack(alignment: .leading) {
                                Text(date)
                                    .font(.title2) // Increased font size
                                    .fontWeight(.bold) // Made it bold
                                    .foregroundColor(.primary)
                                    .padding(.leading)
                                    .padding(.top, 8)
                                
                                ForEach(entries) { entry in
                                    JournalEntryCard(entry: entry, viewModel: viewModel)
                                        .padding(.horizontal)
                                }
                            }
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
