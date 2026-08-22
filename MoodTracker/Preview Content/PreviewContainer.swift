//
//  PreviewContainer.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftData
import Foundation

#if DEBUG
enum PreviewContainer {
    
    static func make() -> ModelContainer {
        
        do {
            let container = try ModelContainer(for: SavedMood.self, configurations: .init(isStoredInMemoryOnly: true))
            return container
            
        } catch {
            print("Failed to create container for preview...", error.localizedDescription)
            fatalError("Failed to create container for preview...")
        }
    }
}
#endif
