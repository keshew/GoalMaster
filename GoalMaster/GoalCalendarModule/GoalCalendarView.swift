import SwiftUI

struct GoalCalendarView: View {
    @StateObject var goalCalendarModel = GoalCalendarViewModel()
    
    var body: some View {
        ZStack {
            Image(.obBg)
                .resizable()
                .ignoresSafeArea()
                .overlay {
                    Color(red: 65/255, green: 96/255, blue: 130/255)
                        .opacity(0.9)
                        .ignoresSafeArea()
                }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Calendar")
                        .OpenBold(size: 30)
                    
                    Rectangle()
                        .fill(.white)
                        .overlay {
                            VStack(spacing: 0) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(goalCalendarModel.displayedMonth)
                                            .OpenBold(size: 26, color: Color(red: 48/255, green: 66/255, blue: 87/255))
                                        
                                        Text("Today: \(goalCalendarModel.todayString)")
                                            .Open(size: 16, color: Color(red: 48/255, green: 66/255, blue: 87/255))
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Button(action: {
                                            goalCalendarModel.changeMonth(by: -1)
                                        }) {
                                            Image(.leftCalendar)
                                                .resizable()
                                                .frame(width: 18, height: 18)
                                        }
                                        
                                        Button(action: {
                                            goalCalendarModel.changeMonth(by: 1)
                                        }) {
                                            Image(.rightCalendar)
                                                .resizable()
                                                .frame(width: 18, height: 18)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                                Rectangle()
                                    .fill(Color(red: 234/255, green: 236/255, blue: 238/255))
                                    .frame(height: 1)
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                
                                GeometryReader { geo in
                                    let dayWidth = (geo.size.width - 16 * 2) / 7
                                    
                                    VStack(spacing: 8) {
                                        HStack(spacing: 0) {
                                            ForEach(goalCalendarModel.contact.dayOfWeek.indices, id: \.self) { index in
                                                Text(goalCalendarModel.contact.dayOfWeek[index])
                                                    .Open(size: 12, color: Color(red: 83/255, green: 109/255, blue: 137/255))
                                                    .frame(width: dayWidth)
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.top)
                                        
                                        VStack(spacing: 5) {
                                            let calendar = Calendar.current
                                            let daysInMonth = goalCalendarModel.numberOfDays(in: goalCalendarModel.currentDate)
                                            let firstWeekdayIndex = goalCalendarModel.firstDayOfMonth(date: goalCalendarModel.currentDate) // 0 = Sun
                                            let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: goalCalendarModel.currentDate)!
                                            let daysInPreviousMonth = goalCalendarModel.numberOfDays(in: previousMonthDate)
                                            
                                            ForEach(0..<5, id: \.self) { row in
                                                HStack(spacing: 8) {
                                                    ForEach(0..<7, id: \.self) { column in
                                                        let dayIndex = row * 7 + column
                                                        let dayNumber = dayIndex - firstWeekdayIndex + 1
                                                        let (displayText, isCurrentMonth) = goalCalendarModel.dayInfo(
                                                            dayNumber: dayNumber,
                                                            daysInMonth: daysInMonth,
                                                            daysInPreviousMonth: daysInPreviousMonth
                                                        )
                                                        
                                                        let cellDate = goalCalendarModel.dateForCell(
                                                            dayNumber: dayNumber,
                                                            currentDate: goalCalendarModel.currentDate,
                                                            calendar: calendar
                                                        )
                                                        
                                                        let isToday = calendar.isDateInToday(cellDate)
                                                        let isSelected = goalCalendarModel.selectedDate != nil && calendar.isDate(goalCalendarModel.selectedDate!, inSameDayAs: cellDate)
                                                        
                                                        let colors = goalCalendarModel.colorsForDay(isToday: isToday, isSelected: isSelected, isCurrentMonth: isCurrentMonth)
                                                        
                                                        Rectangle()
                                                            .fill(colors.background)
                                                            .frame(
                                                                width: max(0, dayWidth - 8),
                                                                height: max(0, dayWidth - 10)
                                                            )
                                                            .cornerRadius(6)
                                                            .overlay(
                                                                Text(displayText)
                                                                    .font(.caption)
                                                                    .foregroundColor(colors.text)
                                                                    .overlay {
                                                                        goalCalendarModel.taskCirclesOverlay(for: cellDate)
                                                                            .offset(y: 13)
                                                                    }
                                                            )
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 6)
                                                                    .stroke(colors.border, lineWidth: colors.borderWidth)
                                                            )
                                                            .onTapGesture {
                                                                goalCalendarModel.selectedDate = cellDate
                                                            }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                .frame(height: getSizeOffset(for: UIScreen.main.bounds.width))
                            }
                        }
                        .frame(height: getSizeGeometry(for: UIScreen.main.bounds.width))
                        .cornerRadius(20)
                        .padding(.horizontal)
                    
                    HStack {
                        Text("Today’s Goals")
                            .OpenBold(size: 22)
                            .padding(.leading)
                            .padding(.top)
                        
                        Spacer()
                    }
                    
                    VStack(spacing: 10) {
                        ForEach(goalCalendarModel.sortedTasks, id: \.id) { task in
                            GoalsView(task: task) {
                                if !UserDefaultsManager().isGuest() {
                                    goalCalendarModel.loadTasks()
                                }
                            }
                        }
                    }
                    
                    Color(.clear)
                        .frame(height: 60)
                }
            }
            
            Button(action: {
                goalCalendarModel.isAdd = true
            }) {
                Image(.addBtn)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
            .position(x: UIScreen.main.bounds.width / 1.12, y: UIScreen.main.bounds.height / 1.3)
            .disabled(UserDefaultsManager().isGuest() ? true : false)
            .opacity(UserDefaultsManager().isGuest() ? 0.5 : 1)
        }
        
        .fullScreenCover(isPresented: $goalCalendarModel.isAdd) {
            GoalCreateTaskView()
        }
        .onAppear() {
            if !UserDefaultsManager().isGuest() {
                goalCalendarModel.loadTasks()
            }
        }
    }
    func getSizeGeometry(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 830
        } else if width > 650 {
            return 670
        } else if width < 220 {
            return 350
        } else {
            return 350
        }
    }
    
    func getSizeOffset(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 700
        } else if width > 650 {
            return 570
        } else if width < 220 {
            return 255
        } else {
            return 255
        }
    }
}

#Preview {
    GoalCalendarView()
}
