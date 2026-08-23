//
//  BackgroundView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI

struct BackgroundView<Content: View>: View {
    
    var color: Color
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            color
                .ignoresSafeArea()
                .opacity(0.2)
            
            content()
        }
    }
}

#Preview {
    BackgroundView(color: .blue) {
        Text("Hello, Background!")
    }
}
