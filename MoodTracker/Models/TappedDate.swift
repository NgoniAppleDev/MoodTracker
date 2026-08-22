//
//  TappedDate.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import Foundation

struct TappedDate: Identifiable {
    
    var id: UUID = UUID()
    var date: Date
    var mood: Mood
}
