import SwiftUI

class GoalSplashViewModel: ObservableObject {
    let contact = GoalSplashModel()
    @Published var currentIndex = 0
    @Published var isDone = false
}
