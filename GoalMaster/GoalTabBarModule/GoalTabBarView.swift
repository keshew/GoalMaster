import SwiftUI

struct GoalTabBarView: View {
    @StateObject var goalTabBarModel =  GoalTabBarViewModel()
    @State private var selectedTab: CustomTabBar.TabType = .Calendar
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selectedTab == .Calendar {
                    GoalCalendarView()
                } else if selectedTab == .Goals {
                    GoalTasksView()
                } else if selectedTab == .Profile {
                    GoalProfileView()
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GoalTabBarView()
}

