import SwiftUI

class GoalLoginViewModel: ObservableObject {
    let contact = GoalLoginModel()
    @Published var user = ""
    @Published var password = ""
    @Published var isBack = false
    @Published var isGuest = false
    @Published var isCreate = false
    @Published var isTab = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func login() {
        guard !user.isEmpty, !password.isEmpty else {
            alertMessage = "Please enter both username and password."
            showAlert = true
            return
        }
        
        NetworkManager.shared.login(username: user, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.isTab = true
                    UserDefaultsManager().saveCurrentEmail(self?.user ?? "")
                    UserDefaultsManager().savePassword(self?.password ?? "")
                    UserDefaultsManager().saveLoginStatus(true)
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }
}
