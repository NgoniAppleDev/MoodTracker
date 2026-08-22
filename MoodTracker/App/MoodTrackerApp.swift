//
//  MoodTrackerApp.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI
import SwiftData

@main
struct MoodTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: SavedMood.self)
    }
}
