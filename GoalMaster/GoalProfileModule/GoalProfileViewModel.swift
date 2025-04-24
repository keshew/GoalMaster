import SwiftUI

class GoalProfileViewModel: ObservableObject {
    let contact = GoalProfileModel()
    @Published var isLog = false
    @Published var isSigh = false
    @Published var isLogOut = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var isNotif: Bool {
        didSet {
            UserDefaults.standard.set(isNotif, forKey: "isNotif")
        }
    }
    
    @Published var isEmail: Bool {
        didSet {
            UserDefaults.standard.set(isEmail, forKey: "isEmail")
        }
    }
    
    init() {
        self.isNotif = UserDefaults.standard.bool(forKey: "isTog")
        self.isEmail = UserDefaults.standard.bool(forKey: "isEmail")
    }
    
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaultsManager().getEmail(),
              let password = UserDefaultsManager().getPassword() else {
            self.errorMessage = "Error"
            self.showError = true
            completion(false)
            return
        }
        
        NetworkManager.shared
            .logOut(username: username, password: password) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(_):
                        UserDefaultsManager().saveLoginStatus(false)
                        UserDefaultsManager().deletePhone()
                        UserDefaultsManager().deletePassword()
                        completion(true)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                        completion(false)
                    }
                }
            }
    }
}
