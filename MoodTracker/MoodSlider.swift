//
//  MoodSlider.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

struct MoodSlider: View {
    
    @Binding var moodValue: Double
    
    private let size: CGFloat = 40
    private let steps = 5
    @State private var xValue: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            
            let trackWidth = geometry.size.width
            let stepWidth = (trackWidth - size) / CGFloat(steps - 1)
            
            ZStack(alignment: .leading) {
                
                Capsule()
                    .frame(height: size)
                    .frame(maxWidth: .infinity)
                    .opacity(0.2)
                    .foregroundStyle(.gray)
                
                Circle()
                    .frame(width: size, height: size)
                    .foregroundStyle(.white)
                    .shadow(radius: 1)
                    .offset(x: xValue)
                    .gesture(DragGesture().onChanged { value in
                                let minX: CGFloat = 0
                                let maxX = trackWidth - size
                                let currentX = value.location.x
                                let clampedX = min(max(minX, currentX), maxX)
                        
                                let step = round(clampedX / stepWidth)
                                self.xValue = clampedX
//                                self.xValue = step * stepWidth
                                self.moodValue = Double(step)
                            }
                    )
            }
        }
        .frame(height: size)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MoodSlider(moodValue: .constant(0.5))
        .padding()
}
