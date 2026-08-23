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
    
    var moodValue: Double = 4
    
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        let allValidCases = Mood.allCases.filter { $0 != .unknown }
        return allValidCases[index]
    }
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func updateMoodValue(sliderXValue: CGFloat, stepWidth: CGFloat, maxX: CGFloat) {
        
        let clampedX = min(max(0, sliderXValue), maxX)
        let step = round(clampedX / stepWidth)
        
        moodValue = step
    }
    
    func saveMood(_ mood: Mood? = nil, onDate date: Date = .now) {
        
        if let existingMood =
            try? context.fetch(FetchDescriptor<SavedMood>()).first(where: { Calendar.current.isDate($0.date, inSameDayAs: date.normalizedDate) }) {
            
            existingMood.mood = mood ?? selectedMood
            
        } else {
            
            let savedMood = SavedMood(date: date.normalizedDate, mood: mood ?? selectedMood)
            context.insert(savedMood)
        }
        
        try? context.save()
    }
}
