//
//  MainTabView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @State private var readStateOfMindViewModel: ReadStateOfMindViewModel
    @State private var logStateOfMindViewModel: LogStateOfMindViewModel
    
    init(healthKitManager: HealthKitManager = .shared) {
        _readStateOfMindViewModel = State(initialValue: ReadStateOfMindViewModel(healthKitManager: healthKitManager))
        _logStateOfMindViewModel = State(initialValue: LogStateOfMindViewModel(healthKitManager: healthKitManager))
    }
    
    var body: some View {
        
        TabView {
            Tab("Mood Selection", systemImage: "square.and.pencil") {
                NavigationStack {
                    LogStateOfMindView()
                }
            }
            
            Tab("Mood History", systemImage: "list.dash") {
                MoodHistoryView()
            }
            
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .tint(Color(.label))
        .environment(readStateOfMindViewModel)
        .environment(logStateOfMindViewModel)
    }
}

#Preview {
    MainTabView()
        .environment(\.healthKitManager, .shared)
}
