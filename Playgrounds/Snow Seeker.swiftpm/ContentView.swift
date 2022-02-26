import SwiftUI

struct ContentView: View {
    enum SortTypes {
        case defaultOrder, alphabeticalOrder, countryOrder
    }
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var searchText = ""
    
    @StateObject var favorites = Favorites()
    
    @State private var showingSortOptions = false
    @State private var sortType = SortTypes.defaultOrder
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in
                NavigationLink{
                    ResortView(resort: resort)
                } label: {
                    HStack{
                        Image("\(resort.country)@2x")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        VStack(alignment: .leading){
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .navigationTitle("Resorts")
            .toolbar {
                Button{
                    showingSortOptions = true
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle")
                }
            }
            .confirmationDialog("Sort by", isPresented: $showingSortOptions) {
                Button("Default"){
                    sortType = .defaultOrder
                }
                Button("Alphabetical"){
                    sortType = .alphabeticalOrder
                }
                Button("Country") {
                    sortType = .countryOrder
                }
            }
            WelcomeView()
        }
        .environmentObject(favorites)
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter {$0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var sortedResorts: [Resort] {
        switch sortType {
        case .defaultOrder:
            return filteredResorts
        case .alphabeticalOrder:
            return filteredResorts.sorted {$0.name < $1.name}
        case .countryOrder:
            return filteredResorts.sorted {$0.country < $1.country}
        }
    }
}
