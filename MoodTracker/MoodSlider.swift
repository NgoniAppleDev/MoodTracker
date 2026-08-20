//
//  MoodSlider.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

struct MoodSlider: View {
    
    var viewModel: ModelSelectionScreenViewModel
    
    private let size: CGFloat = 40
    private let steps = Mood.allCases.count
    
    @State private var xValue: CGFloat = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        GeometryReader { geometry in
            
            let trackWidth = geometry.size.width
            let maxX = trackWidth - size
            let stepWidth = maxX / CGFloat(steps - 1)
            
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
                    .gesture(
                        DragGesture().onChanged { value in
                            viewModel.updateMoodValue(
                                    sliderXValue: value.location.x,
                                    stepWidth: stepWidth,
                                    size: size,
                                    trackWidth: trackWidth,
                                    reduceMotion: reduceMotion
                                )
                            
                            let snappedX = CGFloat(viewModel.moodValue) * stepWidth
                            self.xValue = snappedX
                        }
                    )
            }
            .onAppear {
                self.xValue = CGFloat(viewModel.moodValue) * stepWidth
            }
        }
        .frame(height: size)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    MoodSlider(viewModel: ModelSelectionScreenViewModel())
        .padding()
}
