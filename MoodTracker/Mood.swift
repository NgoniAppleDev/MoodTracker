//
//  Mood.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

enum Mood: String, CaseIterable, Hashable, Codable {
    case extremelyUnpleasant = "Extremely Unpleasant"
    case veryUnpleasant = "Very UnPleasant"
    case unpleasant = "Unpleasant"
    case slightlyUnpleasant = "Slightly Unpleasant"
    case neutral = "Neutral"
    case slightlyPleasant = "Slightly Pleasant"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    case extremelyPleasant = "Extremely Pleasant"
    
    var color: Color {
        switch self {
        case .extremelyUnpleasant:
            Color(.extremelyUnpleasant)
        case .veryUnpleasant:
            Color(.veryUnpleasant)
        case .unpleasant:
            Color(.unpleasant)
        case .slightlyUnpleasant:
            Color(.slightlyUnpleasant)
        case .neutral:
            Color(.neutral)
        case .slightlyPleasant:
            Color(.slightlyPleasant)
        case .pleasant:
            Color(.pleasant)
        case .veryPleasant:
            Color(.veryPleasant)
        case .extremelyPleasant:
            Color(.extremelyPleasant)
        }
    }
    
    var emoji: Image {
        switch self {
        case .extremelyUnpleasant:
            Image(.extremelyUnpleasant)
        case .veryUnpleasant:
            Image(.veryUnpleasant)
        case .unpleasant:
            Image(.unpleasant)
        case .slightlyUnpleasant:
            Image(.slightlyUnpleasant)
        case .neutral:
            Image(.neutral)
        case .slightlyPleasant:
            Image(.slightlyPleasant)
        case .pleasant:
            Image(.pleasant)
        case .veryPleasant:
            Image(.veryPleasant)
        case .extremelyPleasant:
            Image(.extremelyPleasant)
        }
    }
}
