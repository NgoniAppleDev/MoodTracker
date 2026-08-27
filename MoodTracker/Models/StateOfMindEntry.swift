//
//  StateOfMindEntry.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 26/8/2026.
//

import SwiftUI
import HealthKit

struct StateOfMindEntry: Identifiable {
    let id: UUID
    let date: Date
    let kind: StateOfMindKind
    let mood: Mood
    let labels: Set<MoodLabel>
    let associations: Set<MoodAssociation>
    let metadata: [String: Any]?
    
    init(
        id: UUID = UUID(),
        date: Date = .now,
        kind: StateOfMindKind =  .momentaryEmotion,
        mood: Mood,
        labels: Set<MoodLabel> = [],
        associations: Set<MoodAssociation> = [],
        metadata: [String : Any]? = nil
    ) {
        self.id = id
        self.date = date
        self.kind = kind
        self.mood = mood
        self.labels = labels
        self.associations = associations
        self.metadata = metadata
    }
}

extension StateOfMindEntry {
    
    init(_ stateOfMind: HKStateOfMind) {
        self.init(
            id: stateOfMind.uuid,
            date: stateOfMind.startDate,
            kind: StateOfMindKind(stateOfMind.kind),
            mood: Mood(valence: stateOfMind.valence),
            labels: Set(stateOfMind.labels.map(MoodLabel.init)),
            associations: Set(stateOfMind.associations.map(MoodAssociation.init)),
            metadata: stateOfMind.metadata
        )
    }
    
    func makeHealthKitStateOfMind() -> HKStateOfMind {
        
        HKStateOfMind(
            date: date,
            kind: kind.healthKitKind,
            valence: mood.valence,
            labels: Array(labels.map(\.healthKitLabel)),
            associations: Array(associations.map(\.healthKitAssociation)),
            metadata: metadata
        )
        
    }
    
}
