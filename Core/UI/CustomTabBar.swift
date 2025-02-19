import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    private let accentColor = Color(hex: "8B5DFF") // Remove # from hex
    
    var body: some View {
        HStack {
            
            Spacer()
            
            Button {
                selectedTab = .home
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "chart.bar.fill")
                        .font(.system(size: 20))
                    Text("Home")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == .home ? accentColor : .gray)
            }
            
            
            Spacer()
            
            Button {
                selectedTab = .journal
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.system(size: 20))
                    Text("Journal")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == .journal ? accentColor : .gray)
            }
            
            Spacer()
            
            Button {
                selectedTab = .calendar
            } label: {
                VStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                    Text("Calendar")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == .calendar ? accentColor : .gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}
