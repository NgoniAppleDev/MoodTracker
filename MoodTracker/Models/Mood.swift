//
//  Mood.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

enum Mood: String, CaseIterable, Hashable, Codable, Identifiable {
    case extremelyUnpleasant = "Extremely Unpleasant"
    case veryUnpleasant = "Very UnPleasant"
    case unpleasant = "Unpleasant"
    case slightlyUnpleasant = "Slightly Unpleasant"
    case neutral = "Neutral"
    case slightlyPleasant = "Slightly Pleasant"
    case pleasant = "Pleasant"
    case veryPleasant = "Very Pleasant"
    case extremelyPleasant = "Extremely Pleasant"
    case unknown = "Unknown"
    
    var id: Self { self }
    
    static var validCases: [Mood] {
        allCases.filter { $0 != .unknown }
    }
    
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
        case .unknown:
            Color(.systemBackground)
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
        case .unknown:
            Image(.wink)
        }
    }
    
    static func nearest(to valence: Double) -> Mood {
        let clampedValence = min(max(valence, -1), 1)
        
        let normalized = (clampedValence + 1) / 2
        
        let index = Int(
            round(
                normalized * Double(validCases.count - 1)
            )
        )
        
        return validCases[index]
    }

}

extension Mood {
    
    static func interpolatedColor(for valence: Double) -> Color {
        
        let valence = min(max(valence, -1), 1)
        
        // Convert -1...1 → 0...1
        let normalized = (valence + 1) / 2
        
        let colors = validCases.map(\.color)
        
        // Locate the two surrounding moods
        let scaled = normalized * Double(colors.count - 1)
        let lowerIndex = Int(floor(scaled))
        let upperIndex = min(lowerIndex + 1, colors.count - 1)
        
        let fraction = scaled - Double(lowerIndex)
        
        return colors[lowerIndex].interpolated(to: colors[upperIndex], fraction: fraction)
    }
}
