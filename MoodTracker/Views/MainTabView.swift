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
    
    init(context: ModelContext) {
        _readStateOfMindViewModel = State(initialValue: ReadStateOfMindViewModel(context: context))
        _logStateOfMindViewModel = State(initialValue: LogStateOfMindViewModel(context: context))
    }
    
    var body: some View {
        
        TabView {
            Tab("Mood Selection", systemImage: "square.and.pencil") {
                LogStateOfMindView(selectedMood: .extremelyPleasant) { mood, date in
                    readStateOfMindViewModel.updateLocalSavedMoods(mood, onDate: date)
                }
            }
            
            Tab("Mood History", systemImage: "list.dash") {
                MoodHistoryView()
            }
        }
        .tint(Color(.label))
        .environment(readStateOfMindViewModel)
        .environment(logStateOfMindViewModel)
    }
}

#Preview {
    let container = PreviewContainer.make()
    
    MainTabView(context: container.mainContext)
        .modelContainer(container)
        .environment(ReadStateOfMindViewModel(context: container.mainContext))
        .environment(LogStateOfMindViewModel(context: container.mainContext))
}
