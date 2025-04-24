import SwiftUI

struct GoalOnboardingView: View {
    @StateObject var goalOnboardingModel =  GoalOnboardingViewModel()

    var body: some View {
        ZStack {
            Image(.obBg)
                .resizable()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    Image(.ob)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350, height: 530)
                        
                    Rectangle()
                        .frame(height: 250)
                        .opacity(0.65)
                        .overlay {
                            VStack(spacing: 15) {
                                Button(action: {
                                    goalOnboardingModel.isSigh = true
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                        .frame(height: 50)
                                        .overlay {
                                            Text("Get started!")
                                                .Open(size: 16, color: .black)
                                        }
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                
                                Button(action: {
                                    goalOnboardingModel.isLog = true
                                }) {
                                    Rectangle()
                                        .fill(.clear)
                                        .frame(height: 50)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(red: 255/255, green: 251/255, blue: 101/255), lineWidth: 1)
                                            Text("Log In")
                                                .Open(size: 16, color: Color(red: 255/255, green: 251/255, blue: 101/255))
                                        }
                                        .cornerRadius(16)
                                        .padding(.horizontal)
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 20)
                        }
                        .cornerRadius(20)
                        .ignoresSafeArea()
                        .offset(y: getSpacing(for: UIScreen.main.bounds.width))
                }
                .padding(.top)
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380)
        }
        .fullScreenCover(isPresented: $goalOnboardingModel.isLog) {
            GoalLoginView()
        }
        .fullScreenCover(isPresented: $goalOnboardingModel.isSigh) {
            GoalSplashView()
        }
    }
    
    func getSpacing(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 620
        } else if width > 650 {
            return 470
          } else if width < 380 {
              return 80
          } else {
              return 80
          }
      }
}

#Preview {
    GoalOnboardingView()
}

