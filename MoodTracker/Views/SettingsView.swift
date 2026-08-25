//
//  SettingsView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 25/8/2026.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.healthKitManager) private var healthKitManager
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Apple Health") {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(.iconAppleHealth)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .shadow(radius: 1)
                            Text("Apple Health")
                        }
                        
                        Spacer()
                        
                        Button(healthKitManager.isAuthenticated ? "Connected" : "Disconnected") {
                            healthKitManager.trigger.toggle()
                        }
                        .tint(Color.accent)
                        .disabled(healthKitManager.isAuthenticated)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
        .environment(\.healthKitManager, .shared)
}
