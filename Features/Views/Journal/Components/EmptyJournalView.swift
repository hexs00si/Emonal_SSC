//
//  SwiftUIView.swift
//  Emonal
//
//  Created by Shravan Rajput on 20/02/25.
//
import SwiftUI

struct EmptyJournalView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Every thought matters")
                .font(.system(size: 28, weight: .bold))
            
            Text("Tap the plus(+) icon to start journalling")
                .font(.system(size: 17))
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
    }
}
