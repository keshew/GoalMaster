import SwiftUI

struct GoalEditView: View {
    @StateObject var goalEditModel =  GoalEditViewModel()

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
                    Text("Edit name")
                        .OpenBold(size: 30)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Username")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomTextFiled(text: $goalEditModel.name, placeholder: "Enter username")
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Password")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomSecureFiled(text: $goalEditModel.email, placeholder: "Enter email")
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .fill(Color(red: 181/255, green: 192/255, blue: 205/255))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top, 30)
                    
                    Button(action: {

                    }) {
                        Rectangle()
                            .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                            .frame(height: 50)
                            .overlay {
                                Text("Save")
                                    .Open(size: 16, color: .black)
                            }
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                    .padding(.top, 30)
                }
            }
        }
    }
}

#Preview {
    GoalEditView()
}

