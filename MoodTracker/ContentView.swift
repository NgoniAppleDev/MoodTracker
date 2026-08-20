//
//  ContentView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var moodValue: Double = 0
    
    private var selectedMood: Mood {
        switch moodValue {
        case 0: .veryUnpleasant
        case 1: .unpleasant
        case 2: .neutral
        case 3: .pleasant
        case 4: .veryPleasant
        default: .neutral
        }
    }
    
    var body: some View {
        ZStack {
            selectedMood.color
                .ignoresSafeArea()
                .opacity(0.2)
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                BlobView(color: selectedMood.color)
                
                Spacer()
                
                Text(selectedMood.rawValue)
                    .contentTransition(.numericText())
                    .font(.title)
                
                Spacer()
                
                MoodSlider(moodValue: $moodValue.animation())
                
                Spacer()
                
                Button {
                    // TODO: save the mood
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedMood.color, in: .capsule)
                        .foregroundStyle(.white)
                }
            }
            .padding(40)
        }
    }
}

#Preview {
    ContentView()
}
