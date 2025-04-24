import SwiftUI

struct GoalSignView: View {
    @StateObject var goalSignModel =  GoalSignViewModel()

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
                VStack(alignment: .leading) {
                    HStack {
                        Button(action: {
                            goalSignModel.isBack = true
                        }) {
                            Image(.backBtn2)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Hello!")
                            .OpenBold(size: 26)
                            .padding(.leading)
                        
                        Text("Sign up to continue organizing your\nschedule")
                            .Open(size: 17)
                            .padding(.leading)
                    }
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Username")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomTextFiled(text: $goalSignModel.user, placeholder: "Enter username")
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Email")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomTextFiled(text: $goalSignModel.email, placeholder: "Enter email")
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Password")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomSecureFiled(text: $goalSignModel.password, placeholder: "Enter password")
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Confirm password")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomSecureFiled(text: $goalSignModel.confirmPassword, placeholder: "Confirm password")
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .frame(height: 240)
                        .opacity(0.65)
                        .overlay {
                            VStack(spacing: 15) {
                                Button(action: {
                                    goalSignModel.createAccount()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                        .frame(height: 50)
                                        .overlay {
                                            Text("Create account")
                                                .Open(size: 16, color: .black)
                                        }
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                
                                
                                Button(action: {
                                    goalSignModel.isGuest = true
                                    UserDefaultsManager().enterAsGuest()
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: 50)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(red: 255/255, green: 251/255, blue: 101/255), lineWidth: 1)
                                            Text("Continue as a guest")
                                                .Open(size: 16, color: Color(red: 255/255, green: 251/255, blue: 101/255))
                                        }
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                HStack {
                                    Text("Do you have an account?")
                                        .Open(size: 14)
                                    Button(action: {
                                        goalSignModel.isLogin = true
                                    }) {
                                        Text("Sign In")
                                            .Open(size: 14, color: Color(red: 255/255, green: 251/255, blue: 101/255))
                                    }
                                }
                               
                                Spacer()
                            }
                            .padding(.top, 20)
                        }
                        .cornerRadius(20)
                        .ignoresSafeArea()
                        .offset(y: getSpacing(for: UIScreen.main.bounds.width))
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380)
        }
        .fullScreenCover(isPresented: $goalSignModel.isBack) {
            GoalLoginView()
        }
        .fullScreenCover(isPresented: $goalSignModel.isLogin) {
            GoalLoginView()
        }
        .fullScreenCover(isPresented: $goalSignModel.isGuest) {
            GoalTabBarView()
        }
        .alert(isPresented: $goalSignModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(goalSignModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func getSpacing(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 680
        } else if width > 650 {
            return 510
          } else if width < 380 {
              return 150
          } else {
              return 150
          }
      }
}

#Preview {
    GoalSignView()
}

