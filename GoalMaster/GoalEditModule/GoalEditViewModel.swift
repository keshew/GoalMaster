import SwiftUI

class GoalEditViewModel: ObservableObject {
    let contact = GoalEditModel()
    @Published var name = ""
    @Published var email = ""
}
