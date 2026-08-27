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
    @Environment(\.dismiss) private var dismiss
    
    var selectedMood: Mood? = nil
    var selectedDate: Date = .now
    
    var body: some View {
        BackgroundView(color: viewModel.selectedMoodInterpolatedColor) {
            
            VStack {
                Text("How are you feeling today?")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                BlobView()
                
                Spacer()
                
                MoodTextValueView()
                
                Spacer()
                
                MoodSliderView(viewModel: viewModel)
                
            }
            .padding(40)
            .onAppear {
                if let selectedMood {
                    viewModel.updateSelectedMood(selectedMood)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    SaveButton()
                }
            }
            
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
                    .shadow(color: viewModel.selectedMoodInterpolatedColor, radius: 100)
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
            Task {
                await viewModel.saveMood(selectedMood, onDate: selectedDate)
                dismiss()
            }
        } label: {
            Text("Save")
                .foregroundStyle(.white)
        }
        .id(viewModel.selectedMoodInterpolatedColor)
        .buttonStyle(.glassProminent)
        .tint(viewModel.selectedMoodInterpolatedColor)
    }
}

#Preview {
    NavigationStack {
        LogStateOfMindView()
            .environment(\.healthKitManager, .shared)
    }
}
