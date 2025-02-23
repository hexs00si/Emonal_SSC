import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init() {
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: HomeViewModel(viewContext: context))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    // Home Heading
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Greeting Component
                    GreetingView()
                        .padding(.horizontal)
                    
                    // QuoteCard
                    QuoteCard(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Emotional Wellness Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Emotional Wellness")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Tap to explore your weekly emotional journey. Understand your emotional patterns and celebrate your progress.")
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(3)
                    }
                    .padding(.horizontal)
                    
                    // Tap to view details indicator
                    Text("Tap to view details ⬇️")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.top, 5)

                    // Weekly Emotional Pattern Card with Navigation
                    NavigationLink(destination: EmotionalJourneyView(viewModel: viewModel)) {
                        WeeklyEmotionalPatternCard(viewModel: viewModel)
                            .padding(.horizontal)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
}
