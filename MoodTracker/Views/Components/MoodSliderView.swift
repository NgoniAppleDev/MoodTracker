//
//  MoodSliderView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI
import SwiftData

struct MoodSliderView: View {
    
    var viewModel: LogStateOfMindViewModel
    
    private let size: CGFloat = 40
    private let steps = Mood.validCases.count
    
    var body: some View {
        GeometryReader { geometry in
            
            let trackWidth = geometry.size.width
            let maxX = trackWidth - size
            let stepWidth = maxX / CGFloat(steps - 1)
            let xValueOffset = viewModel.moodValence * maxX
            
            ZStack(alignment: .leading) {
                
                Capsule()
                    .frame(height: size)
                    .frame(maxWidth: .infinity)
                    .opacity(0.2)
                    .foregroundStyle(.gray)
                
                Circle()
                    .frame(width: size, height: size)
                    .foregroundStyle(viewModel.selectedMood.color.gradient)
                    .shadow(radius: 1)
                    .offset(x: xValueOffset)
                    .gesture(
                        DragGesture().onChanged { value in
                            viewModel.updateMoodValue(
                                sliderXValue: value.location.x,
                                stepWidth: stepWidth,
                                maxX: maxX
                            )
                        }
                    )
            }
        }
        .frame(height: size)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MoodSliderView(viewModel: .init(context: PreviewContainer.make().mainContext))
}
