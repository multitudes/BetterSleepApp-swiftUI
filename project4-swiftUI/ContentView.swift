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
    var strengths = ["1 Cup", "2 Cups", "3 Cups", "4 Cups", "5 Cups", "6 Cups", "7 Cups", "8 Cups"]
    
    var body: some View {
        NavigationView {
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
                    Picker(selection: $coffeeAmount, label: Text("Strength")) {
                        ForEach(0 ..< 8) {
                            Text(self.strengths[$0])

                        }
                    }
                }
            } .navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                Button(action: calculateBedtime)
                 {
                    Text("Calculate ")
                }
            )
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("ok")))
            }
        }
}
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    func calculateBedtime(){
        print("Button was tapped!")
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let  formatter = DateFormatter()
            formatter.timeStyle = .short
            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is ..."
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry there was a problem"
        }
        showingAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
