//
//  RootView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import HealthKitUI
import SwiftUI
import SwiftData
import os

nonisolated let logger = Logger(
    subsystem: "com.ngonikatsidzira.MoodTracker",
    category: "MoodTracker"
)

struct RootView: View {
    @State private var healthKitManager: HealthKitManager = .shared
    
    var body: some View {
        MainTabView(healthKitManager: healthKitManager)
            .environment(\.healthKitManager, healthKitManager)
    }
}

#Preview {
    RootView()
}
