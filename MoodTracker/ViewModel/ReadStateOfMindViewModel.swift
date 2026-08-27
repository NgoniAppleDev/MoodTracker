//
//  MoodSelectionScreenViewModel.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import HealthKit
import SwiftUI
import Observation
import SwiftData
import os


enum DateChangeFactor {
    
    case day
    case month
    case year
}

enum ReadStateOfMindState {
    case idle
    case loading
    case loaded
    case failed
}

@Observable
class ReadStateOfMindViewModel {
    
    // MARK: - Properties
    
    private let healthKitManager: HealthKitManager

    private var savedStatesOfMind: [Date: [StateOfMindEntry]] {
        Dictionary(grouping: healthKitManager.stateOfMindData, by: { $0.date.normalizedDate })
    }
    
    var selectedDate = Date() {
        didSet {
            updateMonthDays()
        }
    }
    
    var monthDays: [Date] = []
    
    var emptyDays: Int {
        let calendar = Calendar.current
        
        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: selectedDate)
        )!
        
        return calendar.component(.weekday, from: startOfMonth) - 1
    }
    
    var formattedSelectedDate: String {
        selectedDate.formatted(.dateTime.month(.wide).year())
    }
    
    var isShowingCurrentMonth: Bool {
        Calendar.current.isDate(selectedDate, equalTo: Date(), toGranularity: .month)
    }
    
    private(set) var state: ReadStateOfMindState = .idle {
        didSet {
            if state == .failed {
                self.isShowingError = true
            }
        }
    }
    private(set) var error: HealthKitError? = nil
    var isShowingError: Bool = false
    
    
    // MARK: - Initializer
    
    init(healthKitManager: HealthKitManager) {
        self.healthKitManager = healthKitManager
        
        updateMonthDays()
    }
    
    
    // MARK: - Methods
    
    // MARK: navigating states of mind
    
    func moodForDay(_ date: Date) -> Mood {
        guard let statesOfMind = savedStatesOfMind[date.normalizedDate] else {
            return .unknown
        }
        
        if let dailyMood = statesOfMind
            .filter({ $0.kind == .dailyMood })
            .max(by: { $0.date < $1.date }) {
            return dailyMood.mood
        }
        
        let momentaryEmotions = statesOfMind.filter {
            $0.kind == .momentaryEmotion
        }
        
        guard !momentaryEmotions.isEmpty else {
            return .unknown
        }
        
        let averageValence = momentaryEmotions
            .map(\.mood.valence)
            .reduce(0, +) / Double(momentaryEmotions.count)
        
        return .nearest(to: averageValence)
    }
    
    func load() async {
        state = .idle
        error = nil
        
        do {
            try await healthKitManager.loadStateOfMindData()
            state = .loaded
        } catch let error as HealthKitError {
            self.error = error
            state = .failed
        } catch {
            state = .failed
        }
    }
    
    
    // MARK: navigating the calendar
    
    func goToCurrentMonth() {
        self.selectedDate = .now
    }
    
    func goBack(by factor: DateChangeFactor) {
        
        switch factor {
        case .day:
            return
        case .month:
            goBackByMonth()
        case .year:
            return
        }
    }
    
    func goForward(by factor: DateChangeFactor) {
        
        switch factor {
        case .day:
            return
        case .month:
            goForwardByMonth()
        case .year:
            return
        }
    }
    
    func formattedDayOfMonth(for date: Date) -> String {
        date.formatted(.dateTime.day())
    }
    
    private func updateMonthDays() {
        let calendar = Calendar.current
        
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate))!
        let daysInMonth = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        monthDays = daysInMonth
            .compactMap { calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth) }
    }
    
    private func goBackByMonth() {
        
        self.selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate)!
    }
    
    private func goForwardByMonth() {
        
        self.selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate)!
    }
}

