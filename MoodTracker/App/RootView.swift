//
//  RootView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(\.modelContext) private var context
    
    var body: some View {
        MainTabView(context: context)
    }
}

#Preview {
    RootView()
}
