import Foundation

struct Card: Codable {
    let promp: String
    let answer: String
    
    static let example = Card(promp: "What is the capital of Vietnam?", answer: "Hanoi")
}
