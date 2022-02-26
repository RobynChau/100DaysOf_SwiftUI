import Foundation
import CoreImage
import CoreLocation

struct Contact: Codable, Identifiable {
    var id = UUID()
    var name: String
    var imagePath: Data?
    
    var locationRecord = false
    var latitude: Double = 0
    var longtitude: Double = 0
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longtitude)
    }
}

extension Contact: Equatable {
    static func ==(lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}
