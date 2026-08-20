//
//  BlobView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

struct BlobView: View {
    
    var mood: Mood
    
    private let size: CGFloat = 250
    
    @State private var isAnimating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                mood.emoji
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width)
                    .animation(.none, value: mood)
                    .id(mood)
                    .transition(reduceMotion ? .identity : .asymmetric(
                            insertion: .push(from: .leading),
                            removal: .push(from: .trailing)
                        )
                    )
                    .scaleEffect(isAnimating ? 0.5 : 1)
                    .onChange(of: mood) {
                        guard reduceMotion == false else { return }
                        
                        isAnimating = true
                        
                        withAnimation {
                            isAnimating = false
                        }
                    }
            }
        }
        .frame(height: size)
    }
}

#Preview {
    BlobView(mood: .neutral)
        .padding()
}
