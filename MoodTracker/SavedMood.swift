//
//  SavedMood.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftData
import Foundation

@Model
class SavedMood {
    
    var date: Date
    var mood: Mood
    
    init(date: Date, mood: Mood) {
        self.date = date
        self.mood = mood
    }
}

extension SavedMood: CustomStringConvertible {
    
    var description: String {
        "SavedMood(\(mood.rawValue) - \(date.formatted(date: .abbreviated, time: .omitted)))"
    }
}
