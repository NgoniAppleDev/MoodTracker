//
//  LogStateOfMindViewModel.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 23/8/2026.
//

import HealthKit
import Observation
import SwiftUI
import SwiftData

@Observable
class LogStateOfMindViewModel {
    
    private let healthKitManager: HealthKitManager
    
    var moodValence: Double = 0
    
    var normalizedValence: Double {
        (moodValence + 1) / 2
    }
    
    var selectedMood: Mood {
        Mood.nearest(to: moodValence)
    }
    
    var selectedMoodInterpolatedColor: Color {
        Mood.interpolatedColor(for: moodValence)
    }
    
    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
    
    func updateMoodValue(sliderXValue: CGFloat, maxX: CGFloat) {
        
        let clampedX = min(max(0, sliderXValue), maxX)
        
        let normalizedValue = clampedX / maxX
        
        moodValence = Double(normalizedValue * 2 - 1)
    }
    
    @discardableResult
    func saveMood(_ mood: Mood? = nil, onDate date: Date = .now) async -> Bool {
        
        do {
            try await healthKitManager.save(
                for: .momentaryEmotion,
                onDate: date,
                withValence: self.moodValence,
                labels: [],
                associations: []
            )
            
            return true
        } catch {
            return false
        }
    }
    
    func updateSelectedMood(_ mood: Mood) {
        
        moodValence = mood.valence
    }
    
}
