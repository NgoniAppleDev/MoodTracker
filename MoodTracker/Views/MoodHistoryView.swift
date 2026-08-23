//
//  MoodHistoryView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 22/8/2026.
//

import SwiftUI
import SwiftData

struct MoodHistoryView: View {
    
    @Environment(ReadStateOfMindViewModel.self) private var viewModel
    @State private var tappedDate: TappedDate?
    
    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                CalendarView()
                
                Spacer()
            }
            .padding()
            .navigationTitle("Mood History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Components

extension MoodHistoryView {
    
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button {
                viewModel.goBack(by: .month)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.largeTitle)
            }
            
            Spacer()
            
            VStack {
                Text(viewModel.formattedSelectedDate)
                    .font(.largeTitle)
                    .foregroundStyle(Color(.label))
                
                if !viewModel.isShowingCurrentMonth {
                    Button("Today", action: viewModel.goToCurrentMonth)
                        .padding(.bottom)
                }
            }
            
            Spacer()
            
            Button {
                viewModel.goForward(by: .month)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.largeTitle)
            }
        }
        .tint(Color.accent)
        .padding(.bottom)
    }
    
    @ViewBuilder
    private func CalendarView() -> some View {
        
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        LazyVGrid(columns: columns) {
            DaysOfWeekView()
            DaysOfMonthView()
        }
    }
    
    @ViewBuilder
    private func DaysOfWeekView() -> some View {
        
        let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        ForEach(daysOfWeek, id: \.self) { dayOfWeek in
            Text(dayOfWeek)
                .font(.caption)
        }
    }
    
    @ViewBuilder
    private func DaysOfMonthView() -> some View {
        
        ForEach(0..<viewModel.emptyDays, id: \.self) { _ in
            Color.clear
                .frame(width: 40, height: 40)
        }
        
        ForEach(viewModel.monthDays, id: \.self) { dayOfMonth in
            let moodForDay = viewModel.moodForDay(dayOfMonth)
            
            return Button {
                self.tappedDate = .init(date: dayOfMonth, mood: moodForDay)
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            dayOfMonth.isInTheFuture ?
                            Color(.secondarySystemBackground).gradient : moodForDay.color.gradient
                        )
                        .frame(width: 40, height: 40)
                    
                    Text(viewModel.formattedDayOfMonth(for: dayOfMonth))
                        .foregroundStyle(
                            dayOfMonth.isInTheFuture ? .gray : moodForDay == .unknown ? Color(.label) : .white
                        )
                }
            }
            .opacity(dayOfMonth.isInTheFuture ? 0.5 : 1)
            .disabled(dayOfMonth.isInTheFuture)
        }
    }
    
}


#Preview {
    let container = PreviewContainer.make()
    MoodHistoryView()
        .modelContainer(container)
        .environment(ReadStateOfMindViewModel(context: container.mainContext))
}
