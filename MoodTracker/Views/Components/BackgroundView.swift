//
//  BackgroundView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    
    var selectedMood: Mood
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            selectedMood.color
                .ignoresSafeArea()
                .opacity(0.2)
            
            content()
        }
    }
}

#Preview {
    BackgroundView(selectedMood: .extremelyPleasant) {
        Text("Hello, Background!")
    }
}
