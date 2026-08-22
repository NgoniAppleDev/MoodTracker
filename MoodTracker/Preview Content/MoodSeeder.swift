//
//  MoodSeeder.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import Foundation

struct MoodSeeder {
    
    static func generate(startingFrom today: Date = .now, forYears years: Int = 5) -> [SavedMood] {
        
        let calendar = Calendar.current
        
        guard let startDate = calendar.date(byAdding: .year, value: -years, to: today)
        else { return [] }
        
        var results: [SavedMood] = []
        
        var date = calendar.startOfDay(for: startDate)
        let todayStart = calendar.startOfDay(for: today)
        
        while date <= todayStart {
            
            // Randomly decide whether this day has a mood.
            if Bool.random() {
                
                results.append(
                    SavedMood(date: date, mood: Mood.allCases.filter { $0 != .unknown }.randomElement()!)
                )
            }
            
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: date)
            else { break }
            
            date = nextDay
        }
        
        return results
    }
}
