import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    @State private var showingCrewNames = false
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns){
                    ForEach(missions) { mission in
                        NavigationLink{
                            MissionView(mission: mission, astronauts: astronauts)
                        } label: {
                            VStack{
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                    .accessibilityLabel(mission.imageLabel)
                                VStack{
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Group{
                                        if showingCrewNames {
                                            Text(mission.crewNames)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                        else {
                                            Text(mission.formattedLaunchDate)
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                    }
                                    
                                }
                                .padding(.vertical)
                                .frame(maxWidth: .infinity)
                                .background(.lightBackGround)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.lightBackGround))
                        }
                    }
                }
                .padding([.horizontal, .bottom])
            }
            .navigationTitle("Moonshot")
            .background(.darkBackGround)
            .preferredColorScheme(.dark)
            .toolbar{
                Button(showingCrewNames ? "Show date" : "Show crew") {
                    showingCrewNames.toggle()
                }
            }
        }
    }
}
