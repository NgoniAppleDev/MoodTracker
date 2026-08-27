//
//  StateOfMindKind.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 26/8/2026.
//

import SwiftUI
import HealthKit

enum StateOfMindKind: String, CaseIterable, Identifiable {
    case momentaryEmotion
    case dailyMood
    
    var id: Self { self }
    
    var title: LocalizedStringKey {
        switch self {
        case .momentaryEmotion:
            "Momentary Emotion"
        case .dailyMood:
            "Daily Mood"
        }
    }
}

extension StateOfMindKind {
    
    init(_ kind: HKStateOfMind.Kind) {
        switch kind {
        case .momentaryEmotion:
            self = .momentaryEmotion
            
        case .dailyMood:
            self = .dailyMood
            
        @unknown default:
            self = .momentaryEmotion
        }
    }
    
    var healthKitKind: HKStateOfMind.Kind {
        switch self {
        case .momentaryEmotion:
                .momentaryEmotion
        case .dailyMood:
                .dailyMood
        }
    }
}
