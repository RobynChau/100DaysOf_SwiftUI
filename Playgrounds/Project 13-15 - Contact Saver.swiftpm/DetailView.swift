import SwiftUI
import MapKit

struct DetailView: View {
    let locationFetcher = LocationFetcher()
    var contact: Contact
    
    @State private var pickerTab = 0
    var body: some View {
        VStack {
            Picker("", selection: $pickerTab){
                Text("Photo").tag(0)
                Text("Event Location").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            if pickerTab == 0 {
                if let imageData = contact.imagePath {
                    Image(uiImage: UIImage(data: imageData)!)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .tag("Photo")
                }
            } else {
                if contact.locationRecord {
                    MapView(annotation: getAnnotation())
                } else {
                    Text("Location was not recorded for this contact")
                        .padding()
                }
            }
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    init(contact: Contact){
        self.contact = contact
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: contact.latitude, longitude: contact.longtitude)
        
        return annotation
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(contact: Contact(name: "Tim Cook", latitude: 20, longtitude: 20))
    }
}
