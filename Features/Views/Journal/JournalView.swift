//
//  SwiftUIView.swift
//  Emonal
//
//  Created by Shravan Rajput on 20/02/25.
//
import SwiftUI

struct JournalView: View {
    @State private var showingNewEntrySheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Text("Your Journal")
                    .font(.title2.bold())
                Spacer()
                Button(action: {
                    showingNewEntrySheet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(hex: "8B5DFF"))
                }
            }
            .padding()
            
            // Wave Header Component
            WaveHeaderView()
            
            // Empty State Component
            EmptyJournalView()
            
            Spacer()
        }
    }
}
