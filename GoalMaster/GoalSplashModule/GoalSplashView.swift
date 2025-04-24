import SwiftUI

struct GoalSplashView: View {
    @StateObject var goalSplashModel =  GoalSplashViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack(alignment: .bottom) {
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
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(.backBtn)
                                .resizable()
                                .frame(width: 25, height: 25)
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    
                    Text(goalSplashModel.contact.label[goalSplashModel.currentIndex])
                        .OpenBold(size: 28)
                    
                    Image(goalSplashModel.contact.images[goalSplashModel.currentIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 370, height: 430)
                    
                    Text(goalSplashModel.contact.label2[goalSplashModel.currentIndex])
                        .Open(size: 18)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: 180)
                        .opacity(0.65)
                        .overlay {
                            VStack(spacing: 15) {
                                Button(action: {
                                    if goalSplashModel.currentIndex <= 1 {
                                        goalSplashModel.currentIndex += 1
                                    } else {
                                        goalSplashModel.isDone = true
                                    }
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                        .frame(height: 50)
                                        .overlay {
                                            HStack {
                                                Spacer()
                                                
                                                Text("Next")
                                                    .Open(size: 16, color: .black)
                                                
                                                Spacer()
                                                
                                                Image(.forwradBtn)
                                                    .resizable()
                                                    .frame(width: 20, height: 15)
                                                    .padding(.trailing)
                                            }
                                        }
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                
                                HStack {
                                    Rectangle()
                                        .fill(goalSplashModel.currentIndex == 0 ? Color(red: 201/255, green: 200/255, blue: 159/255) : Color(red: 102/255, green: 128/255, blue: 159/255))
                                        .frame(height: 15)
                                        .cornerRadius(20)
                                    
                                    Rectangle()
                                        .fill(goalSplashModel.currentIndex == 1 ? Color(red: 201/255, green: 200/255, blue: 159/255) : Color(red: 102/255, green: 128/255, blue: 159/255))
                                        .frame(height: 15)
                                        .cornerRadius(20)
                                    
                                    Rectangle()
                                        .fill(goalSplashModel.currentIndex == 2 ? Color(red: 201/255, green: 200/255, blue: 159/255) : Color(red: 102/255, green: 128/255, blue: 159/255))
                                        .frame(height: 15)
                                        .cornerRadius(20)
                                }
                                .padding(.horizontal, 20)
                                
                                
                                Button(action: {
                                    goalSplashModel.isDone = true
                                }) {
                                    Text("Skip")
                                        .Open(size: 15,
                                              color: Color(red: 102/255, green: 128/255, blue: 159/255))
                                }
                                Spacer()
                            }
                            .padding(.top, 20)
                        }
                        .cornerRadius(20)
                        .ignoresSafeArea()
                        .offset(y: goalSplashModel.currentIndex == 0 ? getSpacing(for: UIScreen.main.bounds.width) : (goalSplashModel.currentIndex == 1 ? getSpacing2(for: UIScreen.main.bounds.width) : getSpacing3(for: UIScreen.main.bounds.width)))
                    
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380)
        }
        .fullScreenCover(isPresented: $goalSplashModel.isDone) {
            GoalLoginView()
        }
    }
    
    func getSpacing(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 620
        } else if width > 650 {
            return 470
          } else if width < 380 {
              return 10
          } else {
              return 10
          }
      }
    
    func getSpacing2(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 620
        } else if width > 650 {
            return 470
          }  else if width < 380 {
              return 80
          } else {
              return 34
          }
      }
    
    func getSpacing3(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 620
        } else if width > 650 {
            return 470
          }  else if width < 380 {
              return 80
          } else {
              return 59
          }
      }
}

#Preview {
    GoalSplashView()
}

