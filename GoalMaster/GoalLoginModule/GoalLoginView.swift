import SwiftUI

struct GoalLoginView: View {
    @StateObject var goalLoginModel =  GoalLoginViewModel()

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
                            goalLoginModel.isBack = true
                        }) {
                            Image(.backBtn2)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading)
                        }
                        
                        Spacer()
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Welcome Back")
                            .OpenBold(size: 26)
                            .padding(.leading)
                        
                        Text("Sign in to continue organizing your\nschedule")
                            .Open(size: 17)
                            .padding(.leading)
                    }
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Username")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomTextFiled(text: $goalLoginModel.user, placeholder: "Enter username")
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Password")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomSecureFiled(text: $goalLoginModel.password, placeholder: "Enter password")
                        }
                    }
                    .padding(.top)
                    
                    Rectangle()
                        .frame(height: 240)
                        .opacity(0.65)
                        .overlay {
                            VStack(spacing: 15) {
                                Button(action: {
                                    goalLoginModel.login()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                        .frame(height: 50)
                                        .overlay {
                                            Text("Log in")
                                                .Open(size: 16, color: .black)
                                        }
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                
                                
                                Button(action: {
                                    goalLoginModel.isGuest = true
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
                                    Text("Don't have an account?")
                                        .Open(size: 14)
                                    Button(action: {
                                        goalLoginModel.isCreate = true
                                    }) {
                                        Text("Sign Up")
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
        .fullScreenCover(isPresented: $goalLoginModel.isBack) {
            GoalSplashView()
        }
        .fullScreenCover(isPresented: $goalLoginModel.isCreate) {
            GoalSignView()
        }
        .fullScreenCover(isPresented: $goalLoginModel.isGuest) {
            GoalTabBarView()
        }
        .fullScreenCover(isPresented: $goalLoginModel.isTab) {
            GoalTabBarView()
        }
        .alert(isPresented: $goalLoginModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(goalLoginModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func getSpacing(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 830
            } else if width > 650 {
            return 670
          }  else if width < 220 {
              return 10
          } else if width > 430 {
              return 380
          } else {
              return 290
          }
      }
}

#Preview {
    GoalLoginView()
}
