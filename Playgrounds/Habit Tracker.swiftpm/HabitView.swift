import SwiftUI

struct HabitView: View {
    let habit: HabitItem
    let habits: Habits
    
    var body: some View {
        Form{
            Text("Activity: \(habit.name)")
            Text("Type: \(habit.type)")
            Text("Start date: \(habit.formattedStartDate)")
            Button("Completed"){
                let temp = HabitItem(name: habit.name, startDate: habit.startDate, count: habit.count + 1, type: habit.type, description: habit.description)
                if let index = habits.items.firstIndex(of: habit) {
                    habits.items[index] = temp
                }
            }
        }
        .navigationBarTitle("Edit Habit")
    }
    init(habit: HabitItem, habits: Habits){
        self.habit = habit
        self.habits = habits
    }
}

struct HabitView_Previews: PreviewProvider {
    static var habit = HabitItem(name: "Learn SwiftUI", startDate: Date.now, count: 0, type: "Intellectual", description: "SwiftUI is an amazing framework to create apps for Apple's platforms")
    static var previews: some View {
        HabitView(habit: habit, habits: Habits())
    }
}
