//
//  MoodSelectionScreenViewModel.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI
import Observation
import SwiftData


enum DateChangeFactor {
    
    case day
    case month
    case year
}

@Observable
class ReadStateOfMindViewModel {
    
    // MARK: - Properties
    
    private let context: ModelContext

    private var savedMoods: [Date: Mood] = [:]
    
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
    
    
    // MARK: - Initializer
    
    init(context: ModelContext) {
        self.context = context
        fetchSavedMoods()
        updateMonthDays()
    }
    
    
    // MARK: - Methods
    
    // MARK: navigating moods
    
    func fetchSavedMoods() {
        
        do {
            
            let fetchDescriptor = FetchDescriptor<SavedMood>()
            let fetchedMoods = try context.fetch(fetchDescriptor)
            let seededMoods = MoodSeeder.generate() // FIXME: should remove this in production...
            
            var moods = Dictionary(uniqueKeysWithValues: seededMoods.map { ($0.date.normalizedDate, $0.mood) })
            
            moods.merge(fetchedMoods.map { ($0.date.normalizedDate, $0.mood) }) { _, fetchedMood in
                    fetchedMood
                }
            
            self.savedMoods = moods
            
        } catch {
            // FIXME: should handle errors
            print(error.localizedDescription)
        }
    }
    
    func moodForDay(_ date: Date) -> Mood {
        
        savedMoods[date] ?? .unknown
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

