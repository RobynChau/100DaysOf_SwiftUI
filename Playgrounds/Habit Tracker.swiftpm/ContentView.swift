import SwiftUI

struct ContentView: View {
    @StateObject var habits = Habits()
    @State private var showingAddItem = false
    var body: some View {
        NavigationView{
            List{
                ForEach(habits.items) { item in
                    NavigationLink{
                        HabitView(habit: item, habits: habits)
                    } label: {
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            HStack{
                                Text("Completed")
                                Text(item.count, format: .number)
                                    .foregroundColor(item.count>0 ? .green : .red)
                                Text("times")
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("Habit Tracker")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button {
                    showingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
                    .sheet(isPresented: $showingAddItem) {
                        AddView(habits: habits)
                    }
            )
        }
    }
    func removeItems(at offsets: IndexSet){
        habits.items.remove(atOffsets: offsets)
    }
}
