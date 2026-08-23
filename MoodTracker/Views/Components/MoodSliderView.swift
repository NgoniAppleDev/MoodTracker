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
    private let steps = Mood.allCases.count - 1 // excluding the unknown case...
    
    @State private var xValue: CGFloat = 0
    
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
                    .foregroundStyle(viewModel.selectedMood.color.gradient)
                    .shadow(radius: 1)
                    .offset(x: xValue)
                    .gesture(
                        DragGesture().onChanged { value in
                            viewModel.updateMoodValue(
                                sliderXValue: value.location.x,
                                stepWidth: stepWidth,
                                maxX: maxX
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

#Preview {
    MoodSliderView(viewModel: .init(context: PreviewContainer.make().mainContext))
}
