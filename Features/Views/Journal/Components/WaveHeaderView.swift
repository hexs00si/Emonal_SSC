//
//  SwiftUIView.swift
//  Emonal
//
//  Created by Shravan Rajput on 20/02/25.
//
import SwiftUI

struct WaveHeaderView: View {
    @State private var waveOffset = CGSize.zero
    
    var body: some View {
        ZStack {
            // Background with gradient and wave animation
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(hex: "8B5DFF"),
                            Color(hex: "6A4DE0")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 80) // Smaller height for a minimalistic look
                .overlay(
                    WaveShape(offset: waveOffset)
                        .fill(Color.white.opacity(0.2))
                        .animation(
                            Animation.linear(duration: 4)
                                .repeatForever(autoreverses: false),
                            value: waveOffset
                        )
                )
                .onAppear {
                    // Start the wave animation
                    withAnimation {
                        waveOffset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
                    }
                }
        }
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct WaveShape: Shape {
    var offset: CGSize
    
    var animatableData: CGSize.AnimatableData {
        get { offset.animatableData }
        set { offset.animatableData = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.5),
            control1: CGPoint(x: width * 0.4, y: height * 0.3),
            control2: CGPoint(x: width * 0.6, y: height * 0.7)
        )
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}
