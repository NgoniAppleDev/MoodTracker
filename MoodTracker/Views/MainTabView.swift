//
//  MainTabView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    
    @State private var viewModel: MoodTrackingViewModel
    
    init(context: ModelContext) {
        _viewModel = State(initialValue: MoodTrackingViewModel(context: context))
    }
    
    var body: some View {
        
        TabView {
            Tab("Mood Selection", systemImage: "square.and.pencil") {
                MoodSelectionScreen()
            }
            
            Tab("Mood History", systemImage: "list.dash") {
                MoodHistoryView()
            }
        }
        .tint(Color(.label))
        .environment(viewModel)
    }
}

#Preview {
    let container = PreviewContainer.make()
    
    MainTabView(context: container.mainContext)
        .modelContainer(container)
        .environment(MoodTrackingViewModel(context: container.mainContext))
}
