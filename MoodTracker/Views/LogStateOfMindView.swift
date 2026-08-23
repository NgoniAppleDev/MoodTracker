//
//  LogStateOfMindView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI
import SwiftData

struct LogStateOfMindView: View {
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(LogStateOfMindViewModel.self) private var viewModel
    
    var body: some View {
        BackgroundView(selectedMood: viewModel.selectedMood) {
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                BlobView()
                
                Spacer()
                
                MoodTextValueView()
                
                Spacer()
                
                MoodSliderView(viewModel: viewModel)
                
                Spacer()
                
                SaveButton()
                
            }
            .padding(40)
            
        }
    }
}


// MARK: - Components

extension LogStateOfMindView {
    
    @ViewBuilder
    private func BlobView() -> some View {
        let size: CGFloat = 250
        
        GeometryReader { proxy in
            ZStack {
                viewModel.selectedMood.emoji
                    .resizable()
                    .scaledToFit()
                    .frame(width: proxy.size.width)
                    .animation(.none, value: viewModel.selectedMood)
                    .shadow(color: viewModel.selectedMood.color, radius: 100)
            }
        }
        .frame(height: size)
    }
    
    @ViewBuilder
    private func MoodTextValueView() -> some View {
        
        Text(viewModel.selectedMood.rawValue)
            .contentTransition(.identity)
            .animation(
                reduceMotion ? .none : .snappy, value: viewModel.selectedMood
            )
            .font(.title)
    }
    
    @ViewBuilder
    private func SaveButton() -> some View {
        
        Button {
            viewModel.saveMood()
        } label: {
            Text("Save")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.selectedMood.color.gradient, in: .capsule)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    let container = PreviewContainer.make()
    
    LogStateOfMindView()
        .modelContainer(container)
        .environment(ReadStateOfMindViewModel(context: container.mainContext))
        .environment(LogStateOfMindViewModel(context: container.mainContext))
}
