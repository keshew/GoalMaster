import SwiftUI

struct GoalProfileView: View {
    @StateObject var goalProfileModel =  GoalProfileViewModel()
    
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
                    Text("Profile")
                        .OpenBold(size: 30)
                    
                    if UserDefaultsManager().isGuest() {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Guest")
                                    .OpenBold(size: 18)
                                    .padding(.top, 5)
                                    .padding(.leading)
                            }
                            
                            Spacer()
                        }
                    } else {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(UserDefaultsManager().getEmail() ?? "Error")")
                                    .OpenBold(size: 18)
                                //
                                //                                Text("artem@example,com")
                                //                                    .Open(size: 14)
                            }
                            
                            Spacer()
                            
                            //                            Image(.edit)
                            //                                .resizable()
                            //                                .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal)
                        .padding(.top, 5)
                    }
                    
                    Rectangle()
                        .fill(Color(red: 181/255, green: 192/255, blue: 205/255))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Push Notifications")
                                .Open(size: 20)
                            
                            Toggle("", isOn: $goalProfileModel.isNotif)
                                .toggleStyle(CustomToggleStyle())
                        }
                        .padding(.horizontal)
                        .padding(.top, UserDefaultsManager().isGuest() ? 20 : 0)
                        if !UserDefaultsManager().isGuest() {
                            HStack {
                                Text("Email Notifications")
                                    .Open(size: 20)
                                
                                Toggle("", isOn: $goalProfileModel.isEmail)
                                    .toggleStyle(CustomToggleStyle())
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Rectangle()
                        .fill(Color(red: 181/255, green: 192/255, blue: 205/255))
                        .frame(height: 1)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    VStack(spacing: 15) {
                        if UserDefaultsManager().isGuest() {
                            Button(action: {
                                goalProfileModel.isSigh = true
                                UserDefaultsManager().quitQuest()
                            }) {
                                Rectangle()
                                    .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                    .frame(height: 50)
                                    .overlay {
                                        Text("Creating account")
                                            .Open(size: 16, color: .black)
                                    }
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                            
                            
                            Button(action: {
                                goalProfileModel.isLog = true
                                UserDefaultsManager().quitQuest()
                            }) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 50)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 255/255, green: 251/255, blue: 101/255), lineWidth: 1)
                                        Text("Log in")
                                            .Open(size: 16, color: Color(red: 255/255, green: 251/255, blue: 101/255))
                                    }
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                        } else {
                            Button(action: {
                                goalProfileModel.isLogOut = true
                                UserDefaultsManager().saveLoginStatus(false)
                            }) {
                                Rectangle()
                                    .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                    .frame(height: 50)
                                    .overlay {
                                        Text("Log Out")
                                            .Open(size: 16, color: .black)
                                    }
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                            
                            
                            Button(action: {
                                goalProfileModel.deleteAccount { success in
                                    if success {
                                        goalProfileModel.isLogOut = true
                                    }
                                }
                            }) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(height: 50)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color(red: 255/255, green: 251/255, blue: 101/255), lineWidth: 1)
                                        Text("Delete account")
                                            .Open(size: 16, color: Color(red: 255/255, green: 251/255, blue: 101/255))
                                    }
                                    .cornerRadius(16)
                                    .padding(.horizontal)
                            }
                        }
                        
                    }
                    .padding(.top, 30)
                }
            }
        }
        .alert(isPresented: $goalProfileModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(goalProfileModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        
        .fullScreenCover(isPresented: $goalProfileModel.isLogOut) {
            GoalLoginView()
        }
        .fullScreenCover(isPresented: $goalProfileModel.isSigh) {
            GoalSignView()
        }
        .fullScreenCover(isPresented: $goalProfileModel.isLog) {
            GoalLoginView()
        }
    }
}

#Preview {
    GoalProfileView()
}
