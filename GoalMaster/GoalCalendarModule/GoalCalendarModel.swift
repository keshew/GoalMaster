import SwiftUI

struct GoalCalendarModel {
    let dayOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
}

struct Task: Codable {
    var repeatt: String
    var date: String
    var finishDate: String
    var isDone: Bool
    var priority: String
    var category: String
    var title: String
    var color: String
    var time: String
    var id: String
    
    enum CodingKeys: String, CodingKey {
        case repeatt = "repeat"
        case date, finishDate, priority, category, title, color, time, id
        case isDone = "isDone"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.repeatt = try container.decode(String.self, forKey: .repeatt)
        self.date = try container.decode(String.self, forKey: .date)
        self.finishDate = try container.decode(String.self, forKey: .finishDate)
        self.isDone = (try? container.decode(Bool.self, forKey: .isDone)) ?? false
        self.priority = try container.decode(String.self, forKey: .priority)
        self.category = try container.decode(String.self, forKey: .category)
        self.title = try container.decode(String.self, forKey: .title)
        self.color = try container.decode(String.self, forKey: .color)
        self.time = try container.decode(String.self, forKey: .time)
        self.id = try container.decode(String.self, forKey: .id)
    }
}

extension Task {
    var priorityOrder: Int {
        switch priority.lowercased() {
        case "hight": return 0
        case "medium": return 1
        case "low": return 2
        default: return 3
        }
    }
    
    var statusOrder: Int {
        if isDone {
            return 1
        } else {
            return 0
        }
    }
}

