//
//  ContentView.swift
//  project4-swiftUI
//
//  Created by Laurent B on 19/10/2019.
//  Copyright © 2019 Laurent B. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 9.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("hi")
                .font(.system(size:25)).bold()
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
                .statusBar(hidden: true)

                Form {
                    Section(header: Text("When do you want to wake up?")) {
                        DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden()
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    Section(header: Text("Desired amount to sleep")){
                        Stepper(value: $sleepAmount, in: 4 ... 12 , step: 0.25){
                            Text("\(sleepAmount, specifier: "%g") hours")
                        }
                    }
                    Section(header: Text("Daily coffee intake")){
                        Picker(selection: $coffeeAmount, label:Text("Cups")) {
                                ForEach(1 ..< 21) {
                                    if $0 == 1 {
                                    Text("\($0) cup")
                                    } else {
                                       Text("\($0) cups")
                                    }
                                }
                            }.pickerStyle(WheelPickerStyle())
                            
                    }
                    
                }
            }
                .navigationBarTitle("BetterRest")
        }
             .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
