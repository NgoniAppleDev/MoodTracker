//
//  MoodPickerSheet.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI

struct MoodPickerSheet: View {
    
    var tappedDate: TappedDate
    var onSave: (_ mood: Mood) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(Mood.allCases) { mood in
                    Button {
                        onSave(mood)
                        dismiss()
                    } label: {
                        moodItem(mood)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Select Mood")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func moodItem(_ mood: Mood) -> some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                mood.emoji
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .shadow(color: mood.color, radius: tappedDate.mood == mood ? 10 : 0)
                
                Text(mood.rawValue.capitalized)
                    .foregroundStyle(Color(.label))
            }
            .frame(maxWidth: .infinity)
            
            if tappedDate.mood == mood {
                Image(systemName: "checkmark.circle")
                    .imageScale(.large)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(mood.color.gradient.opacity(0.3), in: .rect(cornerRadius: 12))
        .padding(.bottom)
        .scaleEffect(tappedDate.mood == mood ? 1 : 0.95)
    }
}

#Preview {
    NavigationStack {
        MoodPickerSheet(
            tappedDate: .init(date: Date(), mood: .extremelyUnpleasant),
            onSave: { _ in }
        )
    }
}
