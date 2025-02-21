import SwiftUI

struct EmptyJournalView: View {
    @State private var animateEmoji = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Every thought matters")
                .font(.system(size: 28, weight: .bold))
                .transition(.opacity)

            Text("Tap the plus(+) icon to start journaling")
                .font(.system(size: 17))
                .foregroundColor(.secondary)

            // Animated Emoji Below the Text
            Text("📝")
                .font(.system(size: 40)) // Bigger emoji
                .offset(y: animateEmoji ? -5 : 0) // Bouncing effect
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: animateEmoji
                )
        }
        .padding(.top, 40)
        .onAppear {
            animateEmoji = true // Start animation when the view appears
        }
    }
}
