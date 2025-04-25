import SwiftUI

struct CustomTextFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .frame(height: 47)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            
            TextField("", text: $text, onEditingChanged: { isEditing in
                if !isEditing {
                    isTextFocused = false
                }
            })
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 16)
            .frame(height: 47)
            .font(.custom("OpenSans-Regular", size: 15))
            .cornerRadius(9)
            .foregroundStyle(Color(red: 153/255, green: 173/255, blue: 200/255))
            .focused($isTextFocused)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Open(size: 16, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                    .frame(height: 47)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomSecureFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .fill(.white)
                .frame(height: 47)
                .cornerRadius(12)
                .padding(.horizontal, 15)
            
            SecureField("", text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            .padding(.horizontal, 16)
            .frame(height: 47)
            .font(.custom("OpenSans-Regular", size: 16))
            .cornerRadius(9)
            .foregroundStyle(Color(red: 174/255, green: 174/255, blue: 187/255))
            .focused($isTextFocused)
            .padding(.horizontal, 15)
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .Open(size: 16, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                    .frame(height: 47)
                    .padding(.leading, 30)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    enum TabType: Int {
        case Calendar
        case Goals
        case Profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Rectangle()
                    .fill(Color(red: 23/255, green: 32/255, blue: 44/255))
                    .frame(height: 100)
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: 35)
                 
                
                Rectangle()
                    .fill(Color(red: 0/255, green: 0/255, blue: 84/255))
                    .frame(height: 50)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: 110)
            }
            
            HStack(spacing: 0) {
                TabBarItem(imageName: "tab1", tab: .Calendar, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab2", tab: .Goals, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab3", tab: .Profile, selectedTab: $selectedTab)
            }
            .padding(.top, 15)
            .frame(height: 60)
        }
    }
}

struct TabBarItem: View {
    let imageName: String
    let tab: CustomTabBar.TabType
    @Binding var selectedTab: CustomTabBar.TabType
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 8) {
                Image(selectedTab == tab ? imageName + "Picked" : imageName)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .opacity(selectedTab == tab ? 1 : 0.4)
                
                Text("\(tab)")
                    .Open(size: 12, color: selectedTab == tab ? Color(red: 255/255, green: 180/255, blue: 70/255) : Color(red: 48/255, green: 66/255, blue: 87/255))
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color(red: 201/255, green: 200/255, blue: 159/255) : Color(red: 102/255, green: 128/255, blue: 159/255))
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(configuration.isOn ? Color(red: 158/255, green: 158/255, blue: 103/255) : Color(red: 55/255, green: 80/255, blue: 109/255))
                        .frame(width: 27, height: 27)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        .padding()
    }
}

struct DateTF: View {
    @Binding var date: Date
    @Binding var secondDate: Date
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 175, height: 54)
                    .cornerRadius(15)
                
                HStack {
                    if date.timeIntervalSince1970 == 0 {
                        Image(.date)
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text("Enter date")
                            .Open(size: 18, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                        Spacer()
                    } else {
                        Text(formattedDate(date: date))
                            .Open(size: 18, color: .black)
                    }
                }
                .padding(.horizontal)
                
                DatePicker(
                    "Date",
                    selection: $date,
                    in: secondDate...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .colorMultiply(.clear)
                .frame(width: 175, height: 54)
                .onChange(of: date, perform: { newDate in
                    selectedDate = newDate
                })
               
            }
            .labelsHidden()
            .frame(width: 175, height: 54)
        }
        .disabled(secondDate == Date(timeIntervalSince1970: 0))
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

struct DateTF2: View {
    @Binding var date: Date
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 175, height: 54)
                    .cornerRadius(15)
                
                HStack {
                    if date.timeIntervalSince1970 == 0 {
                        Image(.date)
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text("Enter date")
                            .Open(size: 18, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                        Spacer()
                    } else {
                        Text(formattedDate(date: date))
                            .Open(size: 18, color: .black)
                    }
                }
                .padding(.horizontal)
                
                DatePicker(
                    "Date",
                    selection: $date,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)
                .colorMultiply(.clear)
                .frame(width: 175, height: 54)
                .onChange(of: date, perform: { newDate in
                    selectedDate = newDate
                })
               
            }
            .labelsHidden()
            .frame(width: 175, height: 54)
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}

struct TimeTF: View {
    @Binding var time: Date
 
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 175, height: 52)
                    .cornerRadius(10)
                
                HStack {
                    if time.timeIntervalSince1970 == 0 {
                        Image(.time2)
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text("Enter time")
                            .Open(size: 18, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                        
                        Spacer()
                    } else {
                        Text(time.formatted(date: .omitted, time: .shortened))
                            .Open(size: 18, color: Color(red: 153/255, green: 173/255, blue: 200/255))
                    }
                }
                .padding(.horizontal)
                
                DatePicker(
                    "Time",
                    selection: $time,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(.compact)
                .colorMultiply(.clear)
                .frame(width: 175, height: 52)
               
            }
            .labelsHidden()
            .frame(width: 175, height: 52)
        }
        .padding(.trailing)
    }
}

struct SimpleDropDownView: View {
    var hint: String
    var options: [String]
    @Binding var selection: String?
    @State private var showOptions = false
    @State private var zIndex: Double = 1000

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                Text(selection ?? hint)
                    .Open(size: 17, color: .black)
                    .lineLimit(1)

                Spacer(minLength: 0)

                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 14, height: 8)
                    .foregroundColor(Color(red: 48/255, green: 66/255, blue: 87/255))
                    .rotationEffect(.degrees(showOptions ? -180 : 0))
                    .padding(.trailing, 5)
            }
            .padding(.horizontal, 15)
            .frame(height: 52)
            .background(Color.white)
            .contentShape(Rectangle())
            .zIndex(zIndex)
            .cornerRadius(10)
            .padding(.horizontal)

            if showOptions {
                OptionsView()
                    .zIndex(zIndex + 1)
                    .padding(.top, 5)
                    .transition(.identity)
                    .animation(.easeInOut(duration: 0.3), value: showOptions)
                    .padding(.horizontal, 15)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showOptions.toggle()
                zIndex += 1
            }
        }
    }

    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                HStack(spacing: 10) {
                    Text(option)
                        .foregroundColor(Color(red: 48/255, green: 66/255, blue: 87/255))
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .foregroundColor(selection == option ? Color.primary : Color.gray)
                .frame(height: 40)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selection = option
                        showOptions = false
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .background(Color(red: 225/255, green: 225/255, blue: 225/255))
        .cornerRadius(10)
    }
}

struct ColorDropDownView: View {
    var hint: String
    var options: [Color]
    @Binding var selection: Color?
    @State private var showOptions = false
    @State private var zIndex: Double = 1000

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                if let color = selection {
                    ZStack {
                        Color(red: 200/255, green: 211/255, blue: 222/255)
                            .frame(width: 22, height: 22)
                            .cornerRadius(11)
                        
                        color
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                    }
                } else {
                    ZStack {
                        Color(red: 200/255, green: 211/255, blue: 222/255)
                            .frame(width: 22, height: 22)
                            .cornerRadius(11)
                        
                        Color(red: 230/255, green: 236/255, blue: 243/255)
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                    }
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 14, height: 8)
                    .foregroundColor(Color(red: 48/255, green: 66/255, blue: 87/255))
                    .rotationEffect(.degrees(showOptions ? -180 : 0))
                    .padding(.trailing, 5)
            }
            .padding(.horizontal, 15)
            .frame(height: 52)
            .background(Color.white)
            .contentShape(Rectangle())
            .zIndex(zIndex)
            .cornerRadius(10)
            .padding(.horizontal)

            if showOptions {
                OptionsView()
                    .zIndex(zIndex + 1)
                    .padding(.top, 5)
                    .transition(.identity)
                    .animation(.easeInOut(duration: 0.3), value: showOptions)
                    .padding(.horizontal, 15)
            }
        }
        .onTapGesture {
            withAnimation(.easeInOut) {
                showOptions.toggle()
                zIndex += 1
            }
        }
    }

    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let option = options[index]
                HStack(spacing: 10) {
                    ZStack {
                        Color(red: 200/255, green: 211/255, blue: 222/255)
                            .frame(width: 22, height: 22)
                            .cornerRadius(11)
                        
                        option
                            .frame(width: 20, height: 20)
                            .cornerRadius(10)
                    }
                    
                    Spacer(minLength: 0)
                }
                .foregroundColor(selection == option ? Color.primary : Color.gray)
                .frame(height: 40)
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selection = option
                        showOptions = false
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .background(Color(red: 225/255, green: 225/255, blue: 225/255))
        .cornerRadius(10)
    }
}


