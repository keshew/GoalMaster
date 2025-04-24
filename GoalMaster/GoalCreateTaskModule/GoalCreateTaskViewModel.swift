import SwiftUI

class GoalCreateTaskViewModel: ObservableObject {
    let contact = GoalCreateTaskModel()
    @Published var name = ""
    @Published var dateStart = Date(timeIntervalSince1970: 0)
    @Published var dateFinish = Date(timeIntervalSince1970: 0)
    @Published var desc = ""
    @Published var isReminder = false
    @Published var time = Date(timeIntervalSince1970: 0)
    
    @Published var isLow = true
    @Published var isMedium = false
    @Published var isHight = false
    
    @Published var selection: String?
    @Published var selectionColor: Color?
    @Published var selectionReminder: String?
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var isDone = false
    
    private var priorityString: String {
        if isLow { return "Low" }
        if isMedium { return "Medium" }
        if isHight { return "High" }
        return "Low"
    }
    
    func saveTask() {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            alertMessage = "Please enter the task name."
            showAlert = true
            return
        }
        
        if dateStart == Date(timeIntervalSince1970: 0) {
            alertMessage = "Please select start date"
            showAlert = true
            return
        }
        
        if dateFinish == Date(timeIntervalSince1970: 0) {
            alertMessage = "Please select finish date"
            showAlert = true
            return
        }
        
        if desc.isEmpty {
            alertMessage = "Please enter description"
            showAlert = true
            return
        }
        
        if selection == nil || selection?.isEmpty == true {
            alertMessage = "Please select category"
            showAlert = true
            return
        }
        
        if selectionColor == nil {
            alertMessage = "Please select color"
            showAlert = true
            return
        }
        
        if selectionReminder != nil {
            if time == Date(timeIntervalSince1970: 0) {
                alertMessage = "Please select time for reminder"
                showAlert = true
                return
            }
        }
        
        sendSaveTaskRequest(
            name: name,
            dateStart: dateStart,
            dateFinish: dateFinish,
            description: desc,
            priority: priorityString,
            category: selection ?? "Work",
            color: selectionColor?.toHex() ?? "#FFFFFF",
            isReminder: isReminder,
            reminderTime: time
        )
    }
    
    private func sendSaveTaskRequest(
        name: String,
        dateStart: Date,
        dateFinish: Date,
        description: String,
        priority: String,
        category: String,
        color: String,
        isReminder: Bool,
        reminderTime: Date
    ) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let username = UserDefaultsManager().getEmail() ?? ""
        
        let task = NetworkManager.Task(
            id: nil,
            title: name,
            date: dateFormatter.string(from: dateStart),
            category: category,
            priority: priority,
            color: color,
            repeatField: "none",
            time: timeFormatter.string(from: reminderTime),
            isDone: false
        )
        
        NetworkManager.shared.setTaskForUser(username: username, task: task) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.isDone = true
                case .failure(let error):
                    self?.alertMessage = "Failed to save task: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            }
        }
    }
}

extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
