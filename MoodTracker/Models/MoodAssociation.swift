//
//  MoodAssociation.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 26/8/2026.
//

import HealthKit
import SwiftUI


enum MoodAssociation: String, CaseIterable, Hashable, Codable, Identifiable {
    case community
    case currentEvents
    case dating
    case education
    case family
    case fitness
    case friends
    case health
    case hobbies
    case identity
    case money
    case partner
    case selfCare
    case spirituality
    case tasks
    case travel
    case work
    case weather
    
    var id: Self { self }
}

extension MoodAssociation {
    var title: LocalizedStringKey {
        switch self {
        case .community:      "Community"
        case .currentEvents:  "Current Events"
        case .dating:         "Dating"
        case .education:      "Education"
        case .family:         "Family"
        case .fitness:        "Fitness"
        case .friends:        "Friends"
        case .health:         "Health"
        case .hobbies:        "Hobbies"
        case .identity:       "Identity"
        case .money:          "Money"
        case .partner:        "Partner"
        case .selfCare:       "Self Care"
        case .spirituality:   "Spirituality"
        case .tasks:          "Tasks"
        case .travel:         "Travel"
        case .work:           "Work"
        case .weather:        "Weather"
        }
    }
        
    init(_ association: HKStateOfMind.Association) {
        switch association {
        case .community:      self = .community
        case .currentEvents:  self = .currentEvents
        case .dating:         self = .dating
        case .education:      self = .education
        case .family:         self = .family
        case .fitness:        self = .fitness
        case .friends:        self = .friends
        case .health:         self = .health
        case .hobbies:        self = .hobbies
        case .identity:       self = .identity
        case .money:          self = .money
        case .partner:        self = .partner
        case .selfCare:       self = .selfCare
        case .spirituality:   self = .spirituality
        case .tasks:          self = .tasks
        case .travel:         self = .travel
        case .work:           self = .work
        case .weather:        self = .weather
        @unknown default:     self = .selfCare
        }
    }
        
    var healthKitAssociation: HKStateOfMind.Association {
        switch self {
        case .community:      .community
        case .currentEvents:  .currentEvents
        case .dating:         .dating
        case .education:      .education
        case .family:         .family
        case .fitness:        .fitness
        case .friends:        .friends
        case .health:         .health
        case .hobbies:        .hobbies
        case .identity:       .identity
        case .money:          .money
        case .partner:        .partner
        case .selfCare:       .selfCare
        case .spirituality:   .spirituality
        case .tasks:          .tasks
        case .travel:         .travel
        case .work:           .work
        case .weather:        .weather
        }
    }
    
}
