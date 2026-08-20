//
//  MoodSelectionScreenViewModel.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI
import Observation

@Observable
class ModelSelectionScreenViewModel {
    
    var moodValue: Double = 4
    
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        return Mood.allCases[index]
    }
    
    func updateMoodValue(sliderXValue: CGFloat, stepWidth: CGFloat, size: CGFloat, trackWidth: CGFloat, reduceMotion: Bool = false) {
        
        let maxX = trackWidth - size
        let clampedX = min(max(0, sliderXValue), maxX)
        
        let step = round(clampedX / stepWidth)
        
        if reduceMotion {
            moodValue = step
        } else {
            withAnimation(.snappy) {
                moodValue = step
            }
        }
    }
}
