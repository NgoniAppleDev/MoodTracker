//
//  MoodLabel.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 26/8/2026.
//

import HealthKit
import SwiftUI

enum MoodLabel: String, CaseIterable, Hashable, Codable, Identifiable {
    case amazed
    case amused
    case angry
    case anxious
    case ashamed
    case brave
    case calm
    case content
    case disappointed
    case discouraged
    case disgusted
    case embarrassed
    case excited
    case frustrated
    case grateful
    case guilty
    case happy
    case hopeless
    case irritated
    case jealous
    case joyful
    case lonely
    case passionate
    case peaceful
    case proud
    case relieved
    case sad
    case scared
    case stressed
    case surprised
    case worried
    case annoyed
    case confident
    case drained
    case hopeful
    case indifferent
    case overwhelmed
    case satisfied
    
    var id: Self { self }
}

extension MoodLabel {
    var title: LocalizedStringKey {
        switch self {
        case .amazed: "Amazed"
        case .amused: "Amused"
        case .angry: "Angry"
        case .anxious: "Anxious"
        case .ashamed: "Ashamed"
        case .brave: "Brave"
        case .calm: "Calm"
        case .content: "Content"
        case .disappointed: "Disappointed"
        case .discouraged: "Discouraged"
        case .disgusted: "Disgusted"
        case .embarrassed: "Embarrassed"
        case .excited: "Excited"
        case .frustrated: "Frustrated"
        case .grateful: "Grateful"
        case .guilty: "Guilty"
        case .happy: "Happy"
        case .hopeless: "Hopeless"
        case .irritated: "Irritated"
        case .jealous: "Jealous"
        case .joyful: "Joyful"
        case .lonely: "Lonely"
        case .passionate: "Passionate"
        case .peaceful: "Peaceful"
        case .proud: "Proud"
        case .relieved: "Relieved"
        case .sad: "Sad"
        case .scared: "Scared"
        case .stressed: "Stressed"
        case .surprised: "Surprised"
        case .worried: "Worried"
        case .annoyed: "Annoyed"
        case .confident: "Confident"
        case .drained: "Drained"
        case .hopeful: "Hopeful"
        case .indifferent: "Indifferent"
        case .overwhelmed: "Overwhelmed"
        case .satisfied: "Satisfied"
        }
    }
        
    init(_ label: HKStateOfMind.Label) {
        switch label {
        case .amazed:       self = .amazed
        case .amused:       self = .amused
        case .angry:        self = .angry
        case .anxious:      self = .anxious
        case .ashamed:      self = .ashamed
        case .brave:        self = .brave
        case .calm:         self = .calm
        case .content:      self = .content
        case .disappointed: self = .disappointed
        case .discouraged:  self = .discouraged
        case .disgusted:    self = .disgusted
        case .embarrassed:  self = .embarrassed
        case .excited:      self = .excited
        case .frustrated:   self = .frustrated
        case .grateful:     self = .grateful
        case .guilty:       self = .guilty
        case .happy:        self = .happy
        case .hopeless:     self = .hopeless
        case .irritated:    self = .irritated
        case .jealous:      self = .jealous
        case .joyful:       self = .joyful
        case .lonely:       self = .lonely
        case .passionate:   self = .passionate
        case .peaceful:     self = .peaceful
        case .proud:        self = .proud
        case .relieved:     self = .relieved
        case .sad:          self = .sad
        case .scared:       self = .scared
        case .stressed:     self = .stressed
        case .surprised:    self = .surprised
        case .worried:      self = .worried
        case .annoyed:      self = .annoyed
        case .confident:    self = .confident
        case .drained:      self = .drained
        case .hopeful:      self = .hopeful
        case .indifferent:  self = .indifferent
        case .overwhelmed:  self = .overwhelmed
        case .satisfied:    self = .satisfied
        @unknown default:   self = .excited
        }
    }
        
    var healthKitLabel: HKStateOfMind.Label {
        switch self {
        case .amazed:       .amazed
        case .amused:       .amused
        case .angry:        .angry
        case .anxious:      .anxious
        case .ashamed:      .ashamed
        case .brave:        .brave
        case .calm:         .calm
        case .content:      .content
        case .disappointed: .disappointed
        case .discouraged:  .discouraged
        case .disgusted:    .disgusted
        case .embarrassed:  .embarrassed
        case .excited:      .excited
        case .frustrated:   .frustrated
        case .grateful:     .grateful
        case .guilty:       .guilty
        case .happy:        .happy
        case .hopeless:     .hopeless
        case .irritated:    .irritated
        case .jealous:      .jealous
        case .joyful:       .joyful
        case .lonely:       .lonely
        case .passionate:   .passionate
        case .peaceful:     .peaceful
        case .proud:        .proud
        case .relieved:     .relieved
        case .sad:          .sad
        case .scared:       .scared
        case .stressed:     .stressed
        case .surprised:    .surprised
        case .worried:      .worried
        case .annoyed:      .annoyed
        case .confident:    .confident
        case .drained:      .drained
        case .hopeful:      .hopeful
        case .indifferent:  .indifferent
        case .overwhelmed:  .overwhelmed
        case .satisfied:    .satisfied
        }
    }
}
