import SwiftUI

class GoalSignViewModel: ObservableObject {
    let contact = GoalSignModel()
    @Published var user = ""
    @Published var password = ""
    @Published var email = ""
    @Published var confirmPassword = ""
    @Published var isBack = false
    @Published var isGuest = false
    @Published var isLogin = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    func createAccount() {
        guard !user.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        NetworkManager.shared.register(username: user, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.isLogin = true
                case .failure(let error):
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                }
            }
        }
    }

}
