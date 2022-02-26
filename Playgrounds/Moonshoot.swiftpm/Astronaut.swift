import Foundation

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    
    var imageLabel: String {
        self.name
    }
}
