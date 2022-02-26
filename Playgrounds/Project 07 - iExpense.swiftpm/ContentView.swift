import SwiftUI

struct ContentView: View {
    enum SortType {
        case none, alphabetical, type
    }
    
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var showingSortOptions = false
    @State private var sortingType = SortType.none
    @State private var searchingText = ""
    
    var body: some View {
        NavigationView{
            List{
                ForEach(sortedItems) { item in
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
            .searchable(text: $searchingText)
            .navigationTitle("iExpense")
            .navigationBarItems (
                leading:
                    Button {
                        showingSortOptions = true
                    } label: {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    },
                trailing:
                    Button{
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
            )
            .confirmationDialog("Sort by", isPresented: $showingSortOptions) {
                Button("Default") {
                    sortingType = .none
                }
                Button("Alphabetical") {
                    sortingType = .alphabetical
                }
                Button("Type") {
                    sortingType = .type
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    func removeItems(at offsets: IndexSet){
        let removeArray = offsets.enumerated()
        for (_, c) in removeArray {
            expenses.items.remove(at: expenses.items.firstIndex(where: {$0.id == sortedItems[c].id}) ?? 0)
        }
    }
    
    var sortedItems: [ExpenseItem] {
        var sortedItems: [ExpenseItem]
        switch sortingType {
        case .none:
            sortedItems = expenses.items
        case .alphabetical:
            sortedItems = expenses.items.sorted {$0.name < $1.name}
        case .type:
            sortedItems = expenses.items.filter {$0.type == "Business"} + expenses.items.filter {$0.type == "Personal"}
        }
        if searchingText.isEmpty {
            return sortedItems
        } else {
            return sortedItems.filter {$0.name.localizedCaseInsensitiveContains(searchingText)}
        }
        
    }

    
    func color(forAmount amount: Double) -> Color {
        if Locale.current.currencyCode == "USD" {
            switch amount {
            case 0..<10:
                return .green
            case 10..<100:
                return .yellow
            default:
                return .red
            }
        } else if Locale.current.currencyCode == "VND" {
            switch amount {
            case 0..<100000:
                return .green
            case 100000..<2000000:
                return .yellow
            default:
                return .red
            }
        } else {
            return .white
        }
        
    }
}
