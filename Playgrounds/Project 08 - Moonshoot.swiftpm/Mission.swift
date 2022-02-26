import Foundation

struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)@2x"
    }
    
    var imageLabel: String {
        displayName
    }
    
    var formattedLaunchDate : String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
    
    var crewNames: String {
        let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        
        var result = ""
        
        for member in crew {
            if let match = astronauts[member.name] {
                result += "\(match.name)\n"
            }
            else{
                fatalError("Crew member \(member.name) not found")
            }
        }
        return String(result.dropLast())
    }
}
