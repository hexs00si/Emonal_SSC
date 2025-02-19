//
//  SwiftUIView.swift
//  Emonal
//
//  Created by Shravan Rajput on 20/02/25.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab: Tab = .journal
    
    var body: some View {
        ZStack {
            // Content based on selected tab
            switch selectedTab {
            case .home:
                HomeView()
            case .journal:
                JournalView()
            case .calendar:
                CalendarView()
            }
            
            // Custom tab bar at bottom
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}
