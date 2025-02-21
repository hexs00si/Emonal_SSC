import SwiftUI

struct RevolvingEmojis: View {
    let entries: [JournalEntry]
    @Binding var emojiAnimationAngle: Double
    
    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(entries.enumerated()), id: \.offset) { index, entry in
                Text(entry.moodEmoji)
                    .font(.system(size: 24))
                    .position(
                        x: geometry.size.width / 2 + 50 * cos(emojiAnimationAngle + Double(index) * (2 * .pi / Double(entries.count))),
                        y: geometry.size.height / 2 + 50 * sin(emojiAnimationAngle + Double(index) * (2 * .pi / Double(entries.count)))
                    )
                    .animation(Animation.linear(duration: 10).repeatForever(autoreverses: false), value: emojiAnimationAngle)
            }
        }
    }
}
