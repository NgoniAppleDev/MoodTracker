//
//  Mood.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

enum Mood: String {
    case veryUnpleasant = "Very UnPleasant"
    case unpleasant = "Unpleasant"
    case neutral = "Neutral"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    
    var color: Color {
        switch self {
        case .veryUnpleasant:
                .red
        case .unpleasant:
                .orange
        case .neutral:
                .yellow
        case .pleasant:
                .green
        case .veryPleasant:
                .blue
        }
    }
}
