import SwiftUI

class GoalTasksViewModel: ObservableObject {
    let contact = GoalTasksModel()
    @Published var isAdd = false
    @Published var tasks: [Task] = []
    @Published var isLoad = false
    
    var sortedTasks: [Task] {
         tasks.sorted {
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
}

extension GoalTasksViewModel {
    var uniqueCategories: [String] {
        Array(Set(tasks.map { $0.category })).sorted()
    }
    
    func filteredTasks(for category: String?) -> [Task] {
        let sorted = sortedTasks
        
        guard let category = category else { return sorted }
        
        return sorted.filter { $0.category == category }
    }
}
