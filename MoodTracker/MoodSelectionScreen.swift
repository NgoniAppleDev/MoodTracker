//
//  MoodSelectionScreen.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI
import SwiftData

struct MoodSelectionScreen: View {
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.modelContext) private var context
    @State private var viewModel = ModelSelectionScreenViewModel()
    
    @Query(sort: \SavedMood.date) var savedMoods: [SavedMood]
    
    var body: some View {
        ZStack {
            viewModel.selectedMood.color
                .ignoresSafeArea()
                .opacity(0.2)
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                BlobView(mood: viewModel.selectedMood)
                    .onTapGesture {
                        print("SavedMood", savedMoods, savedMoods.count)
                    }
                
                Spacer()
                
                Text(viewModel.selectedMood.rawValue)
                    .contentTransition(.identity)
                    .animation(reduceMotion ? .none : .snappy, value: viewModel.selectedMood)
                    .font(.title)
                
                Spacer()
                
                MoodSlider(viewModel: viewModel)
                
                Spacer()
                
                Button {
                    context.insert(
                        SavedMood(date: Date(), mood: viewModel.selectedMood)
                    )
                } label: {
                    Text("Save")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.selectedMood.color.gradient, in: .capsule)
                        .foregroundStyle(.white)
                }
            }
            .padding(40)
            
        }
    }
}

#Preview {
    MoodSelectionScreen()
}
