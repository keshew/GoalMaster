import SwiftUI

final class GoalCalendarViewModel: ObservableObject {
    let contact = GoalCalendarModel()
    @Published var isAdd = false
    @Published var tasks: [Task] = []
    @Published var isLoad = false
    @Published var currentDate = Date()
    @Published var selectedDate: Date? = nil
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var sortedTasks: [Task] {
        filteredTasks.sorted {
            if $0.statusOrder != $1.statusOrder {
                return $0.statusOrder < $1.statusOrder
            }
            return $0.priorityOrder < $1.priorityOrder
        }
    }
    
    var username: String = UserDefaultsManager().getEmail() ?? ""
   
    func loadTasks() {
        let body: [String: Any] = [
            "metod": "getTaskForUser",
            "username": username
        ]
        
        NetworkManager.shared.sendRequest(with: body) { [weak self] (result: Result<[Task], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.tasks = tasks
                    self?.isLoad.toggle()
                case .failure(let error):
                    self?.tasks = []
                    print("Ошибка загрузки задач: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private let calendar = Calendar.current
}

extension GoalCalendarViewModel {
    private var filteredTasks: [Task] {
        if let selectedDate = selectedDate {
            return tasks.filter { task in
                let taskDate = dateFormatter.date(from: task.date)
                return Calendar.current.isDate(taskDate ?? Date(), inSameDayAs: selectedDate)
            }
        } else {
            return tasks.filter { task in
                let taskDate = dateFormatter.date(from: task.date)
                return Calendar.current.isDate(taskDate ?? Date(), inSameDayAs: Date())
            }
        }
    }

    
    var displayedMonth: String {
        currentDate.formatted(.dateTime.year().month(.wide))
    }
    
    var todayString: String {
        Date().formatted(.dateTime.day().month(.wide))
    }
    
    func changeMonth(by value: Int) {
        guard let newDate = calendar.date(byAdding: .month, value: value, to: currentDate) else { return }
        currentDate = newDate
    }
    
    var datesWithTasks: Set<Date> {
        let calendar = Calendar.current
        return Set(tasks.compactMap { task in
            dateFormatter.date(from: task.date)
        })
    }
    
     func taskCirclesOverlay(for date: Date) -> some View {
        let tasksForDate = tasks.filter { task in
            let taskDate = dateFormatter.date(from: task.date)
            return Calendar.current.isDate(taskDate ?? Date(), inSameDayAs: date)
        }
        
        let maxCircles = min(tasksForDate.count, 3)
        
        return HStack(spacing: 1) {
            ForEach(0..<maxCircles, id: \.self) { index in
                if let color = Color(hex: tasksForDate[index].color) {
                    Circle()
                        .fill(color)
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
    
     func colorsForDay(isToday: Bool, isSelected: Bool, isCurrentMonth: Bool) -> (background: Color, text: Color, border: Color, borderWidth: CGFloat) {
        if isToday {
            return (Color.white, Color(red: 83/255, green: 109/255, blue: 137/255), Color(red: 144/255, green: 157/255, blue: 185/255), 2)
        } else if isSelected {
            return (Color(red: 48/255, green: 66/255, blue: 87/255), Color.white, Color(red: 144/255, green: 157/255, blue: 185/255), 1)
        } else if isCurrentMonth {
            return (Color(red: 234/255, green: 236/255, blue: 238/255), Color(red: 83/255, green: 109/255, blue: 137/255), Color.clear, 0)
        } else {
            return (Color(red: 234/255, green: 236/255, blue: 238/255), Color(red: 214/255, green: 218/255, blue: 223/255), Color.clear, 0)
        }
    }
    
     func dateForCell(dayNumber: Int, currentDate: Date, calendar: Calendar) -> Date {
        var components = calendar.dateComponents([.year, .month], from: currentDate)
        
        if dayNumber <= 0 {
            if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentDate) {
                components = calendar.dateComponents([.year, .month], from: previousMonth)
                components.day = dayNumber + numberOfDays(in: previousMonth)
            }
        } else {
            let daysInCurrentMonth = numberOfDays(in: currentDate)
            if dayNumber > daysInCurrentMonth {
                if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentDate) {
                    components = calendar.dateComponents([.year, .month], from: nextMonth)
                    components.day = dayNumber - daysInCurrentMonth
                }
            } else {
                components.day = dayNumber
            }
        }
        
        return calendar.date(from: components) ?? currentDate
    }
    
     func dayInfo(dayNumber: Int, daysInMonth: Int, daysInPreviousMonth: Int) -> (String, Bool) {
        if dayNumber <= 0 {
            return ("\(daysInPreviousMonth + dayNumber)", false)
        } else if dayNumber > daysInMonth {
            return ("\(dayNumber - daysInMonth)", false)
        } else {
            return ("\(dayNumber)", true)
        }
    }
    
     func numberOfDays(in date: Date) -> Int {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return 0 }
        return range.count
    }
    
     func firstDayOfMonth(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDay = calendar.date(from: components) else { return 0 }
        return calendar.component(.weekday, from: firstDay) - 1
    }
}

extension Color {
    init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        formattedHex = formattedHex.replacingOccurrences(of: "#", with: "")
        
        if formattedHex.count != 6 {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
