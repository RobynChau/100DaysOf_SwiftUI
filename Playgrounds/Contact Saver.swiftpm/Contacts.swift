import Foundation

class Contacts: ObservableObject {
    @Published var items = [Contact](){
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([Contact].self, from: savedItems){
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    func sort(){
        items.sort(by: sortCriteria)
    }
    
    private func sortCriteria(p1: Contact, p2: Contact) -> Bool {
        p1.name < p2.name
    }
}
