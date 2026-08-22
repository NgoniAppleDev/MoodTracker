//
//  Date+Extensions.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import Foundation

extension Date {
    
    var normalizedDate: Date {
        
        return Calendar.current.startOfDay(for: self)
    }
    
    var isInTheFuture: Bool {
        self > Date().normalizedDate
    }
}
