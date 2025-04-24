import SwiftUI

struct GoalCreateTaskView: View {
    @StateObject var goalCreateTaskModel =  GoalCreateTaskViewModel()
    @Environment(\.presentationMode) var presentationMode
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
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(.cancel)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .padding(.leading)
                        }
                        
                        Spacer()
                    }
                    
                    Text("New Goal")
                        .OpenBold(size: 30)
                    
                    VStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Goal name")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            CustomTextFiled(text: $goalCreateTaskModel.name, placeholder: "Enter goal name")
                        }
                        .padding(.top, 1)
                        
                        if UIScreen.main.bounds.width > 650 {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Start")
                                        .Open(size: 17)
                                    
                                    DateTF2(date: $goalCreateTaskModel.dateStart)
                                }
                                
                              
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Finish")
                                        .Open(size: 17)
                                    
                                    DateTF(date: $goalCreateTaskModel.dateFinish,
                                           secondDate: $goalCreateTaskModel.dateStart)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        } else {
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Start")
                                        .Open(size: 17)
                                    
                                    DateTF2(date: $goalCreateTaskModel.dateStart)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Finish")
                                        .Open(size: 17)
                                    
                                    DateTF(date: $goalCreateTaskModel.dateFinish,
                                           secondDate: $goalCreateTaskModel.dateStart)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Description")
                            .Open(size: 17)
                            .padding(.leading)
                        
                        CustomTextFiled(text: $goalCreateTaskModel.desc, placeholder: "Add description")
                    }
                    .padding(.top, 1)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Priority")
                                .Open(size: 17)
                            
                            HStack {
                                Button(action: {
                                    goalCreateTaskModel.isLow = true
                                    goalCreateTaskModel.isMedium = false
                                    goalCreateTaskModel.isHight = false
                                }) {
                                    Text("Low")
                                        .Open(size: 16, color: .black)
                                        .padding(8)
                                        .padding(.horizontal, 10)
                                        .background(
                                            ZStack {
                                                if goalCreateTaskModel.isLow {
                                                    Color(red: 255/255, green: 251/255, blue: 101/255)
                                                        .cornerRadius(12)
                                                } else {
                                                    Color.white
                                                        .cornerRadius(12)
                                                }
                                            }
                                        )
                                }
                                
                                Button(action: {
                                    goalCreateTaskModel.isLow = false
                                    goalCreateTaskModel.isMedium = true
                                    goalCreateTaskModel.isHight = false
                                }) {
                                    Text("Medium")
                                        .Open(size: 16, color: .black)
                                        .padding(8)
                                        .padding(.horizontal, 10)
                                        .background(
                                            ZStack {
                                                if goalCreateTaskModel.isMedium {
                                                    Color(red: 255/255, green: 251/255, blue: 101/255)
                                                        .cornerRadius(12)
                                                } else {
                                                    Color.white
                                                        .cornerRadius(12)
                                                }
                                            }
                                        )
                                }
                                
                                Button(action: {
                                    goalCreateTaskModel.isLow = false
                                    goalCreateTaskModel.isMedium = false
                                    goalCreateTaskModel.isHight = true
                                }) {
                                    Text("Hight")
                                        .Open(size: 16, color: .black)
                                        .padding(8)
                                        .padding(.horizontal, 10)
                                        .background(
                                            ZStack {
                                                if goalCreateTaskModel.isHight {
                                                    Color(red: 255/255, green: 251/255, blue: 101/255)
                                                        .cornerRadius(12)
                                                } else {
                                                    Color.white
                                                        .cornerRadius(12)
                                                }
                                            }
                                        )
                                }
                            }
                            
                        }
                        .padding(.top, 1)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack(alignment: .top, spacing: -10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Category")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            HStack {
                                SimpleDropDownView(hint: "Select category",
                                                   options: ["Work",
                                                             "Health",
                                                             "Finance",
                                                             "Adaptive"],
                                                   selection: $goalCreateTaskModel.selection)
                                .frame(width: 250)
                            }
                        }
                        .padding(.top, 1)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Color")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            HStack {
                                ColorDropDownView(hint: "Select color",
                                                  options: [.white,
                                                            Color(red: 255/255, green: 180/255, blue: 70/255),
                                                            Color(red: 55/255, green: 163/255, blue: 255/255),
                                                            Color(red: 153/255, green: 198/255, blue: 237/255),
                                                           ],
                                                  selection: $goalCreateTaskModel.selectionColor)
                            }
                        }
                        .padding(.top, 1)
                    }
                    .padding(.top, 5)
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Reminder")
                                .Open(size: 17)
                                .padding(.leading)
                            
                            HStack {
                                SimpleDropDownView(hint: "No",
                                                   options: ["Once",
                                                             "Every day"],
                                                   selection: $goalCreateTaskModel.selectionReminder)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Reminder")
                                .Open(size: 17, color: .clear)
                                .padding(.leading)
                            
                            TimeTF(time: $goalCreateTaskModel.time)
                        }
                    }
                    .padding(.top, 5)
                    
                    Rectangle()
                        .fill(Color(red: 25/255, green: 34/255, blue: 46/255))
                        .frame(height: 240)
                        .overlay {
                            VStack(spacing: 15) {
                                Button(action: {
                                    goalCreateTaskModel.saveTask()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 255/255, green: 251/255, blue: 101/255))
                                        .frame(height: 50)
                                        .overlay {
                                            Text("Ok")
                                                .Open(size: 16, color: .black)
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
            }
            .scrollDisabled(UIScreen.main.bounds.width > 380)
        }
        .alert(isPresented: $goalCreateTaskModel.showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(goalCreateTaskModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $goalCreateTaskModel.isDone) {
            GoalTabBarView()
        }
    }
    
    func getSpacing(for width: CGFloat) -> CGFloat {
        if width > 850 {
            return 620
        } else if width > 650 {
            return 450
          } else if width > 400 {
              return 8
          } else if width < 220 {
              return 50
          } else {
              return 70
          }
      }
}

#Preview {
    GoalCreateTaskView()
}
