import SwiftUI

struct GoalTasksView: View {
    @StateObject var goalTasksModel = GoalTasksViewModel()
    @State private var selectedCategory: String? = nil
    
    var body: some View {
        ZStack {
            Image(.obBg)
                .resizable()
                .ignoresSafeArea()
                .overlay {
                    Color(red: 65/255, green: 96/255, blue: 130/255)
                        .opacity(0.9)
                        .ignoresSafeArea()
                }
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Text("Calendar")
                        .OpenBold(size: 30)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CategoryPill(
                                title: "All",
                                isSelected: selectedCategory == nil,
                                onTap: { selectedCategory = nil }
                            )
                            
                            ForEach(goalTasksModel.uniqueCategories, id: \.self) { category in
                                CategoryPill(
                                    title: category,
                                    isSelected: selectedCategory == category,
                                    onTap: { selectedCategory = category }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 10) {
                        ForEach(goalTasksModel.filteredTasks(for: selectedCategory), id: \.id) { task in
                            GoalsView(task: task) {
                                if !UserDefaultsManager().isGuest() {
                                    goalTasksModel.loadTasks()
                                }
                            }
                        }
                    }
                    .padding(.top)
                    
                    Color(.clear)
                        .frame(height: 60)
                }
            }
            
            if !UserDefaultsManager().isGuest() {
                Button(action: {
                    goalTasksModel.isAdd = true
                }) {
                    Image(.addBtn)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                .position(x: UIScreen.main.bounds.width / 1.12, y: UIScreen.main.bounds.height / 1.3)
            }
        }
        .onAppear() {
            if !UserDefaultsManager().isGuest() {
                goalTasksModel.loadTasks()
            }
        }
        .fullScreenCover(isPresented: $goalTasksModel.isAdd) {
            GoalCreateTaskView()
        }
    }
}

#Preview {
    GoalTasksView()
}

struct CategoryPill: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Text(title)
            .Open(size: 12, color: isSelected ?
                Color(red: 48/255, green: 66/255, blue: 87/255) :
                Color(red: 172/255, green: 174/255, blue: 188/255))
            .padding(7)
            .background(
                ZStack {
                    Color.white
                        .cornerRadius(5)
                }
            )
            .onTapGesture(perform: onTap)
    }
}
