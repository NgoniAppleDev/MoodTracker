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
    
    init(healthKitManager: HealthKitManager) {
        _readStateOfMindViewModel = State(initialValue: ReadStateOfMindViewModel(healthKitManager: healthKitManager))
        _logStateOfMindViewModel = State(initialValue: LogStateOfMindViewModel(healthKitManager: healthKitManager))
    }
    
    var body: some View {
        
        TabView {
            Tab("Mood Selection", systemImage: "square.and.pencil") {
                NavigationStack {
                    LogStateOfMindView()
                        .alert(
                            logStateOfMindViewModel.error?.errorDescription ?? "Health App Error",
                            isPresented: $logStateOfMindViewModel.isShowingError,
                            presenting: logStateOfMindViewModel.error) { _ in
                                Button("OK", role: .close
                                ) { logStateOfMindViewModel.isShowingError = false }
                            } message: { error in
                                Text(error.completeMessage)
                            }
                }
            }
            
            Tab("Mood History", systemImage: "list.dash") {
                MoodHistoryView()
                    .alert(
                        readStateOfMindViewModel.error?.errorDescription ?? "Health App Error",
                        isPresented: $readStateOfMindViewModel.isShowingError,
                        presenting: readStateOfMindViewModel.error) { _ in
                            Button("OK", role: .close
                            ) { readStateOfMindViewModel.isShowingError = false }
                        } message: { error in
                            Text(error.completeMessage)
                        }
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
    MainTabView(healthKitManager: .shared)
        .environment(\.healthKitManager, .shared)
}
