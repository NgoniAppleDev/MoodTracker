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
            .healthDataAccessRequest(
                store: healthKitManager.healthStore,
                shareTypes: healthKitManager.allTypes,
                readTypes: healthKitManager.allTypes,
                trigger: healthKitManager.trigger,
                completion: { result in
                    switch result {
                    case .success(_):
                        Task { @MainActor in
                            healthKitManager.startStateOfMindObservation()
                        }
                    case .failure(_):
                        break
                    }
                }
            )
            .task {
                if HKHealthStore.isHealthDataAvailable() {
                    healthKitManager.trigger.toggle()
                }
            }
            .environment(\.healthKitManager, healthKitManager)
    }
}

#Preview {
    RootView()
}
