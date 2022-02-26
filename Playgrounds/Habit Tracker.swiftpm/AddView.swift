import SwiftUI

struct AddView: View {
    @ObservedObject var habits: Habits
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var startDate = Date.now
    @State private var count = 0
    @State private var type = "Motor"
    @State private var description = ""
    
    let types = ["Motor", "Intellectual", "Character"]
    var body: some View {
        NavigationView{
            Form{
                TextField("Name", text: $name)
                Picker("Type", selection: $type){
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Desciption", text: $description)
            }
            .navigationTitle("Add new habit")
            .toolbar{
                Button("Add") {
                    addItem()
                }
            }
        }
    }
    func addItem(){
        let item = HabitItem(name: name, startDate: startDate, count: count, type: type, description: description)
        habits.items.append(item)
        dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits())
    }
}
