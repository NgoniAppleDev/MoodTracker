//
//  HealthKitManager+Preview.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 26/8/2026.
//

import HealthKit
import os

enum HealthKitManagerPreview {
    
    static func generateMockHKStateOfMindData(
        startingFrom today: Date = .now, forYears years: Int = 5, withEntriesPerMonth entriesPerMonth: Int = 28
    ) -> [HKStateOfMind] {
        
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(byAdding: .year, value: -years, to: today)
        else { return [] }
        
        var samples: [HKStateOfMind] = []
        let dailyMoodProbability: Double = 0.15
        
        var currentDate = calendar.startOfDay(for: startDate)
        let todayStart = calendar.startOfDay(for: today)
        
        while currentDate <= todayStart {
            
            for _ in 0..<entriesPerMonth {
                
                guard let randomDate = getRandomDate(using: calendar, inMonth: currentDate, through: today) else { continue }
                
                let kind: HKStateOfMind.Kind = Double.random(in: 0...1) < dailyMoodProbability ? .dailyMood : .momentaryEmotion
                
                let valence: Double = Mood.validCases.map(\.valence).randomElement()!
                let labels = getRandomLabels()
                let associations = getRandomAssociations()
                
                let sample = HKStateOfMind(date: randomDate, kind: kind, valence: valence, labels: labels, associations: associations)
                
                samples.append(sample)
            }
            
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) else { break }
            currentDate = nextMonth
        }
        
        return samples
    }
}

fileprivate func getRandomDate(using calendar: Calendar = .current, inMonth currentDate: Date, through maximumDate: Date) -> Date? {
    
    guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate)) else { return nil }
    
    guard let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else { return nil }
    
    let endOfMonth = min(maximumDate, startOfNextMonth.addingTimeInterval(-1))
    
    let interval = endOfMonth.timeIntervalSince(startOfMonth)
    
    guard interval >= 0 else { return nil }
    
    return startOfMonth.addingTimeInterval(TimeInterval.random(in: 0...interval))
}

fileprivate func getRandomLabels() -> [HKStateOfMind.Label] {
    let count: Int = Int.random(in: 1...3)
    return MoodLabel.allCases.shuffled().prefix(count).map(\.healthKitLabel)
}

fileprivate func getRandomAssociations() -> [HKStateOfMind.Association] {
    
    let count = Int.random(in: 1...3)
    return MoodAssociation.allCases.shuffled().prefix(count).map(\.healthKitAssociation)
}
