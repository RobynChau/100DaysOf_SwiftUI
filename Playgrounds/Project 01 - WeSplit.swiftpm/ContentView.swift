import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var totalPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused : Bool
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalPerPerson: Double {
        let peopleCount = Double(totalPeople + 2)
        let tipSelection = Double(tipPercentage)
        return (checkAmount*(1+tipSelection/100))/peopleCount
    }
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Picker("Number of people", selection: $totalPeople) {
                        ForEach(2..<20) {
                            Text("\($0) people")
                        }
                    }
                }
                Section {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self){
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much do you want to leave")
                }
                Section{
                    Text(totalPerPerson, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                        .foregroundColor(tipPercentage == 0 ? .red : .primary)
                }
            }
            .navigationTitle("WeSplit")
            .toolbar{
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer() //Place the Done on the right most
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
        }
}
