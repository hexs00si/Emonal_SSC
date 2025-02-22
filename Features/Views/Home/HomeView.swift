import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    
    init() {
        let context = CoreDataManager.shared.viewContext
        _viewModel = StateObject(wrappedValue: HomeViewModel(viewContext: context))
    }
    
    var body: some View {
        NavigationView { // Wrap the entire view in a NavigationView
            ScrollView {
                VStack(spacing: 16) {
                    // Home Heading
                    Text("Home")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // Greeting Component
                    GreetingView()
                        .padding(.horizontal)
                    
                    // Emotional Wellness Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Emotional Wellness")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Tap to explore your weekly emotional journey. Understand your emotional patterns and celebrate your progress.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                    .padding(.horizontal)
                    
                    // Weekly Emotional Pattern Card with Navigation
                    NavigationLink(destination: EmotionalJourneyView(viewModel: viewModel)) {
                        WeeklyEmotionalPatternCard(viewModel: viewModel)
                            .padding(.horizontal)
                            .contentShape(Rectangle()) // Ensure the entire area is tappable
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
            .navigationBarHidden(true) // Hide the navigation bar if needed
        }
    }
}
