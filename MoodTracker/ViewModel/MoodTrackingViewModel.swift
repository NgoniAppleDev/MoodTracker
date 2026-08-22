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
class MoodTrackingViewModel {
    
    // MARK: - Properties
    
    private let context: ModelContext
    
    var moodValue: Double = 4
    private var savedMoods: [Date: Mood] = [:]
    var selectedMood: Mood {
        let index = Int(round(moodValue))
        let allValidCases = Mood.allCases.filter { $0 != .unknown }
        return allValidCases[index]
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
    
    
    // MARK: - Initializer
    
    init(context: ModelContext) {
        self.context = context
        fetchSavedMoods()
        updateMonthDays()
    }
    
    
    // MARK: - Methods
    
    // MARK: manipulating moods
    
    func updateMoodValue(sliderXValue: CGFloat, stepWidth: CGFloat, maxX: CGFloat) {
        
        let clampedX = min(max(0, sliderXValue), maxX)
        let step = round(clampedX / stepWidth)
        
        moodValue = step
    }
    
    func saveMood(_ mood: Mood? = nil, onDate date: Date = .now) {
        
        if let existingMood =
            try? context.fetch(FetchDescriptor<SavedMood>()).first(where: { Calendar.current.isDate($0.date, inSameDayAs: date.normalizedDate) }) {
            
            existingMood.mood = mood ?? selectedMood
            
        } else {
            
            let savedMood = SavedMood(date: date.normalizedDate, mood: mood ?? selectedMood)
            context.insert(savedMood)
        }
        
        try? context.save()
        
        savedMoods[date.normalizedDate] = mood ?? selectedMood
    }
    
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

