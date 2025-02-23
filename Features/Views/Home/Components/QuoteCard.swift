import SwiftUI

struct QuoteCard: View {
    @ObservedObject var viewModel: HomeViewModel
    @StateObject private var quoteManager = QuoteManager.shared
    @State private var currentQuote: Quote
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        // Initialize with a quote based on the current emotional score
        self._currentQuote = State(initialValue: QuoteManager.shared.getQuoteForScore(viewModel.weeklyEmotionalScore))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                Text("Wisdom for Your Journey")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
            }
            
            Text(currentQuote.text)
                .font(.system(size: 17, weight: .medium))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Text(currentQuote.source)
                    .font(.system(size: 14, weight: .semibold))
                Text(currentQuote.chapter)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white.opacity(0.8))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "8B5DFF").opacity(0.85),
                    Color(hex: "5D8BFF").opacity(0.85)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color(hex: "8B5DFF").opacity(0.15), radius: 8, x: 0, y: 4)
        .onTapGesture {
            withAnimation(.easeInOut) {
                currentQuote = QuoteManager.shared.getQuoteForScore(viewModel.weeklyEmotionalScore)
            }
        }
        .onChange(of: viewModel.weeklyEmotionalScore) { newScore in
            withAnimation(.easeInOut) {
                currentQuote = QuoteManager.shared.getQuoteForScore(newScore)
            }
        }
    }
}

