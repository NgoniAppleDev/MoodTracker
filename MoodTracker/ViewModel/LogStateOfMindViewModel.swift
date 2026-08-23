//
//  LogStateOfMindViewModel.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 23/8/2026.
//

import SwiftUI
import SwiftData
import Observation

@Observable
class LogStateOfMindViewModel {
    
    private let context: ModelContext
    
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
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func updateMoodValue(sliderXValue: CGFloat, maxX: CGFloat) {
        
        let clampedX = min(max(0, sliderXValue), maxX)
        
        let normalizedValue = clampedX / maxX
        
        moodValence = Double(normalizedValue * 2 - 1)
    }
    
    @discardableResult
    func saveMood(_ mood: Mood? = nil, onDate date: Date = .now) -> Bool {
        
        do {
            if let existingMood =
                try context.fetch(FetchDescriptor<SavedMood>()).first(where: { Calendar.current.isDate($0.date, inSameDayAs: date.normalizedDate) }) {
                
                existingMood.mood = mood ?? selectedMood
                
            } else {
                
                let savedMood = SavedMood(date: date.normalizedDate, mood: mood ?? selectedMood)
                context.insert(savedMood)
            }
            
            try context.save()
            
            return true
        } catch {
            return false
        }
    }
    
    func updateSelectedMood(_ mood: Mood) {
        
        guard let index = Mood.validCases.firstIndex(of: mood) else {
            moodValence = 0
            return
        }
        
        let normalizedValue = Double(index) / Double(Mood.validCases.count - 1)
        
        moodValence = (normalizedValue * 2) - 1
    }
    
}
