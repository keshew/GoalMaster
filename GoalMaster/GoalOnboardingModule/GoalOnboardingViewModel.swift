import SwiftUI

class GoalOnboardingViewModel: ObservableObject {
    let contact = GoalOnboardingModel()
    @Published var isLog = false
    @Published var isSigh = false
}
