//
//  ReadStateOfMindViewModelTests.swift
//  MoodTrackerTests
//
//  Created by Ngoni Katsidzira  on 23/8/2026.
//

import Testing
import SwiftData
import Foundation
@testable import MoodTracker

@MainActor @Suite(.tags(.readStateOfMind))
struct ReadStateOfMindViewModelTests {

    @Test
    func initialMonthIsCurrentMonth() {
        
        let container = PreviewContainer.make()
        let viewModel = ReadStateOfMindViewModel(context: container.mainContext)
        
        #expect(viewModel.isShowingCurrentMonth)
    }
    
    @Test
    func goBackOneMonth() {
        
        let container = PreviewContainer.make()
        let viewModel = ReadStateOfMindViewModel(context: container.mainContext)
        let expectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        viewModel.goBack(by: .month)
        
        #expect(Calendar.current.isDate(viewModel.selectedDate, equalTo: expectedMonth, toGranularity: .month))
    }
    
    @Test
    func goForwardOneMonth() {
        
        let container = PreviewContainer.make()
        let viewModel = ReadStateOfMindViewModel(context: container.mainContext)
        let expectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        
        viewModel.goForward(by: .month)
        
        #expect(Calendar.current.isDate(viewModel.selectedDate, equalTo: expectedMonth, toGranularity: .month))
    }
    
    @Test
    func updateMoodUpdatesCalendar() {
        
        let container = PreviewContainer.make()
        let viewModel = ReadStateOfMindViewModel(context: container.mainContext)
        let date = Date()
        
        viewModel.updateLocalSavedMoods(.pleasant, onDate: date)
        
        #expect(viewModel.moodForDay(date) == .pleasant)
    }
    
    @Test
    func updateMoodNormalizesDate() {
        
        let container = PreviewContainer.make()
        let viewModel = ReadStateOfMindViewModel(context: container.mainContext)
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: 18, minute: 30, second: 0, of: Date())!
        
        viewModel.updateLocalSavedMoods(.pleasant, onDate: date)
        let midnight = date.normalizedDate
        
        #expect(viewModel.moodForDay(midnight) == .pleasant)
        #expect(viewModel.moodForDay(date) == .pleasant)
    }

}
