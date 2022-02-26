import SwiftUI

struct AddView: View {
    @ObservedObject var expenses: Expenses
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    let types = ["Business", "Personal"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Add new expense")
            .toolbar{
                Button("Save") {
                    addNewItem()
                }
                .alert(errorTitle, isPresented: $showingError) {
                    Button("OK", role: .cancel){}
                    
                } message: {
                        Text(errorMessage)
                    }
            }
        }
    }
    
    func addNewItem(){
        guard blankName(name: name) else {
            errorMessage(title: "Blank name", message: "New expense's name cannot be blank")
            return
        }
        let item = ExpenseItem(name: name, type: type, amount: amount)
        expenses.items.append(item)
        dismiss()
    }
    
    func blankName(name: String) -> Bool{
        if !name.isEmpty {
            return true
        }
        return false
    }
    func errorMessage(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
