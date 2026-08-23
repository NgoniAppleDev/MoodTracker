//
//  LogStateOfMindViewModelTests.swift
//  MoodTrackerTests
//
//  Created by Ngoni Katsidzira  on 23/8/2026.
//

import Testing
import SwiftData
import Foundation
@testable import MoodTracker

@MainActor @Suite(.tags(.logStateOfMind))
struct LogStateOfMindViewModelTests {

    @Test
    func initialMoodIsNeutral() {
        
        let container = PreviewContainer.make()
        let viewModel = LogStateOfMindViewModel(context: container.mainContext)
        
        #expect(viewModel.moodValence == 0)
        #expect(viewModel.selectedMood == .neutral)
    }
    
    @Test
    func updateSelectedMoodUpdatesValence() {
        
        let container = PreviewContainer.make()
        let viewModel = LogStateOfMindViewModel(context: container.mainContext)
        
        viewModel.updateSelectedMood(.pleasant)
        
        #expect(viewModel.selectedMood == .pleasant)
        #expect(viewModel.moodValence == 0.5)
    }
    
    @Test(arguments: [
        (Mood.extremelyPleasant, 1.0),
        (Mood.extremelyUnpleasant, -1.0)
    ])
    func updateSelectedMoodHandlesExtremes(values: (mood: Mood, valence: Double)) {
        
        let container = PreviewContainer.make()
        let viewModel = LogStateOfMindViewModel(context: container.mainContext)
        
        viewModel.updateSelectedMood(values.mood)
        
        #expect(viewModel.moodValence == values.valence)
        #expect(viewModel.selectedMood == values.mood)
    }
    
    @Test(arguments: [
        (0, 400, -1.0, Mood.extremelyUnpleasant),
        (200, 400, 0.0, .neutral),
        (400, 400, 1.0, .extremelyPleasant)
    ])
    func `moodSlider position aligns correctly with corresponding mood`(
        values: (sliderXValue: CGFloat, maxX: CGFloat, valence: Double, mood: Mood)
    ) {
        
        let container = PreviewContainer.make()
        let viewModel = LogStateOfMindViewModel(context: container.mainContext)
        
        viewModel.updateMoodValue(
            sliderXValue: values.sliderXValue,
            maxX: values.maxX
        )
        
        #expect(viewModel.moodValence == values.valence)
        #expect(viewModel.selectedMood == values.mood)
    }
    
    @Test(arguments: [
        (-100, 400, -1),
        (999, 400, 1)
    ])
    func `slider position overflow correctly clamps the values`(
        values: (sliderXValue: CGFloat, maxX: CGFloat, valence: Double)
    ) {
        
        let container = PreviewContainer.make()
        let viewModel = LogStateOfMindViewModel(context: container.mainContext)
        
        viewModel.updateMoodValue(
            sliderXValue: values.sliderXValue,
            maxX: values.maxX
        )
        
        #expect(viewModel.moodValence == values.valence)
    }
    
    @Test
    func saveMoodCreatesSavedMood() throws {
        
        let container = PreviewContainer.make()
        let context = container.mainContext
        let viewModel = LogStateOfMindViewModel(context: context)
        let date = Date()
        
        let didSave = viewModel.saveMood(.pleasant, onDate: date)
        
        try #require(didSave)
        
        let moods = try context.fetch(FetchDescriptor<SavedMood>())
        
        let firstSavedMood = try #require(moods.first)
        
        #expect(firstSavedMood.mood == .pleasant)
    }
    
    @Test
    func saveMoodUpdatesExistingMood() throws {
        let container = PreviewContainer.make()
        let context = container.mainContext
        let viewModel = LogStateOfMindViewModel(context: context)
        let date = Date()
        
        context.insert(SavedMood(date: date.normalizedDate, mood: .neutral))
        try context.save()
        
        let didSave = viewModel.saveMood(.pleasant, onDate: date)
        
        try #require(didSave)
        
        let moods = try context.fetch(FetchDescriptor<SavedMood>())
        
        let firstSavedMood = try #require(moods.first)
        
        #expect(firstSavedMood.mood == .pleasant)
        
    }
    
    @Test
    func nearestMoodMapsValence() {
        #expect(Mood.nearest(to: 0) == .neutral)
        #expect(Mood.nearest(to: 0.5) == .pleasant)
        #expect(Mood.nearest(to: 1) == .extremelyPleasant)
    }
    
    @Test
    func nearestMoodClampsValence() {
        #expect(Mood.nearest(to: -1) == .extremelyUnpleasant)
        #expect(Mood.nearest(to: 2) == .extremelyPleasant)
    }

}
