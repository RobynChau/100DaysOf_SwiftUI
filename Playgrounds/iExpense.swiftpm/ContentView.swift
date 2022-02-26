import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    var body: some View {
        NavigationView{
            List{
                ForEach(expenses.items) { item in
                    HStack{
                        VStack(alignment: .leading){
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                            .foregroundColor(color(forAmount: item.amount))
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(item.name) with amount \(item.amount)")
                    .accessibilityHint(item.type)
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button{
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    func color(forAmount amount: Double) -> Color {
        switch amount {
        case 0..<10:
            return .green
        case 10..<100:
            return .yellow
        default:
            return .red
        }
    }
}
