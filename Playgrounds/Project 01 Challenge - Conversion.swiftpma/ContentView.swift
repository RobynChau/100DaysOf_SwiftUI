import SwiftUI

struct ContentView: View {
    @State private var inputText = 0.0
    @State private var inputUnit = "Celcius"
    @State private var outputUnit = "Fahrenheit"
    @State private var outputText = 0.0
    @FocusState private var onFocused : Bool
    let units = ["Celcius", "Fahrenheit", "Kelvin"]
    
    var calculatedOutput: Double {
        if (inputUnit == outputUnit){
            return inputText
        }
        else {
            var convertedC = 0.0
            if (inputUnit == "Celcius"){
                convertedC=inputText
            }
            else if (inputUnit == "Fahrenheit"){
                convertedC=(inputText-32) * (5/9)
            }
            else {
                convertedC=inputText-273.15
            }
            if (outputUnit=="Celcius"){
                return convertedC
            }
            else if (outputUnit=="Fahrenheit"){
                return convertedC*9/5 + 32
            }
            else{
                return convertedC + 273.15
            }
        }
    }
    
    var body: some View {
        NavigationView{
            Form {
                Section{
                    TextField ("Input", value: $inputText, format: .number)
                }
                .keyboardType(.numberPad)
                .focused($onFocused)
                Section{
                    Picker("Unit", selection: $inputUnit){
                        ForEach(units, id: \.self){
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Please choose an input unit")
                }
                Section{
                    Picker("Unit", selection: $outputUnit){
                        ForEach(units, id: \.self){
                                Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Please choose an output unit")
                }
                Section {
                    Text("Output: \(calculatedOutput.formatted())")
                }
            }
            .navigationTitle("Conversion")
            .toolbar{
                ToolbarItem(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        onFocused=false
                    }
                }
            }
        }
    }
}
