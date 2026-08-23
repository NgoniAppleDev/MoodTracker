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
    
    var moodValence: Double = 0.5
    
    var selectedMood: Mood {
        let index = Int(round(moodValence * Double(Mood.validCases.count - 1)))
        return Mood.validCases[index]
    }
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func updateMoodValue(sliderXValue: CGFloat, stepWidth: CGFloat, maxX: CGFloat) {
        
        let clampedX = min(max(0, sliderXValue), maxX)
        let step = round(clampedX / stepWidth)
        
        moodValence = step / Double(Mood.validCases.count - 1)
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
            moodValence = 0.5
            return
        }
        
        self.moodValence = Double(index) / Double(Mood.validCases.count - 1)
    }
}
