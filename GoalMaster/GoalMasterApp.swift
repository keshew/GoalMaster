import SwiftUI

@main
struct GoalMasterApp: App {
    var body: some Scene {
        WindowGroup {
            if UserDefaultsManager().checkLogin() {
                GoalTabBarView()
            } else {
                GoalOnboardingView()
                    .onAppear {
                        UserDefaultsManager().quitQuest()
                    }
            }
        }
    }
}
