import SwiftUI
struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]
    var body: some View {
        ScrollView{
            VStack{
                Image("\(astronaut.id)@2x")
                    .resizable()
                    .scaledToFit()
                
                Text(astronaut.description)
                    .padding()
            }
            VStack(alignment: .leading){
                RectangleView()
                
                Text("Mission")
                    .font(.title.bold())
                    .padding(.bottom, 5)
            }
            .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false){
                ForEach(missions) {mission in 
                    HStack{
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 75)
                            .accessibilityLabel(mission.imageLabel)
                        Text(mission.displayName)
                            .font(.headline)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .background(.darkBackGround)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    init(astronaut: Astronaut){
        self.astronaut = astronaut
        
        var matches = [Mission]()
        
        let missions: [Mission] = Bundle.main.decode("missions.json")
        for mission in missions {
            if mission.crew.first(where: {$0.name == astronaut.id}) != nil {
                matches.append(mission)
            }
        }
        self.missions = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts["armstrong"]!)
    }
}
