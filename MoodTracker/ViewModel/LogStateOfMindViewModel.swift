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

enum LogStateOfMindState {
    case idle
    case loading
    case loaded
    case failed
}

@Observable
class LogStateOfMindViewModel {
    
    // MARK: - Properties
    
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
    
    private(set) var state: LogStateOfMindState = .idle {
        didSet {
            if state == .failed {
                self.isShowingError = true
            }
        }
    }
    var error: HealthKitError? = nil
    var isShowingError: Bool = false
    
    
    // MARK: - Methods
    
    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
    }
    
    func updateMoodValue(sliderXValue: CGFloat, maxX: CGFloat) {
        
        let clampedX = min(max(0, sliderXValue), maxX)
        
        let normalizedValue = clampedX / maxX
        
        moodValence = Double(normalizedValue * 2 - 1)
    }
    
    @discardableResult
    func saveMood(_ mood: Mood? = nil, onDate date: Date = .now, for kind: StateOfMindKind = .momentaryEmotion) async -> Bool {
        
        state = .loading
        
        do {
            let entry = StateOfMindEntry(date: date, kind: kind, mood: selectedMood, labels: [], associations: [])
            
            try await healthKitManager.save(entry)
            
            state = .loaded
            
            return true
        } catch let error as HealthKitError {
            self.error = error
            state = .failed
            return false
        } catch {
            state = .failed
            return false
        }
    }
    
    func updateSelectedMood(_ mood: Mood) {
        
        moodValence = mood.valence
    }
    
}
