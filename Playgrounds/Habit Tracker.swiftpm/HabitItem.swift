import Foundation

struct HabitItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let startDate: Date
    let count: Int
    let type: String
    let description: String
    
    var formattedStartDate : String {
        startDate.formatted(date: .abbreviated, time: .omitted) 
    }
}
