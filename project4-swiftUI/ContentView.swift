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
    @State var calculatedBedTime: String = predictionOutput
    var cupCount:Double {
      return Double(coffeeAmount + 1)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text(calculatedBedTime)
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
                        Picker(selection: $coffeeAmount, label: Text("How many cups?")) {
                            ForEach(1 ..< 21) {
                                if $0 == 1 {
                                Text("\($0) cup")
                                } else {
                                   Text("\($0) cups")
                                }
                            }
                        }
                    }
                } .navigationBarTitle("BetterRest")
            }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("ok")))
            }
        }
}
    
    static var predictionOutput: String {
        
        return "hi"
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    func calculateBedtime() -> String {
        
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: Double(sleepAmount), coffee: Double(cupCount))
            print(cupCount)
            let sleepTime = wakeUp - prediction.actualSleep
            
            let  formatter = DateFormatter()
            formatter.timeStyle = .short
            return  "Your ideal bedtime is \(formatter.string(from: sleepTime))"
            
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry there was a problem"
            showingAlert = true
            return "error"
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
