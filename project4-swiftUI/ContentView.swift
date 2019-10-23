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
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 0
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var yourBedTime: String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try
            model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee:  Double(coffeeAmount + 1))
            print("(for debug) cups = \(coffeeAmount + 1)")
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
            
        } catch {
            return "Sorry there was a problem!"
        }
        
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Your Bedtime: \(yourBedTime)")
                .font(.system(size:25)).bold()
                .padding(20)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Capsule())
                .statusBar(hidden: true)
                    .padding(20)

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
