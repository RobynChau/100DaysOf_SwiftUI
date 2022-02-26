import SwiftUI
import MapKit

struct AddContact: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var contacts: Contacts
    
    @State private var name: String = ""
    @State private var showingImagePicker = false
    @State private var uiImage: UIImage?
    @State private var image: Image?
    
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    
    private let locationFetcher = LocationFetcher()
    @State private var imageSourceType: ImageSourceType = .library
    var body: some View {
        NavigationView{
            Form{
                Section("Photo"){
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, lineCap: CGLineCap.round, dash: [5, 5]))
                            .scaledToFit()
                    }
                    HStack{
                        Text("Take picture")
                            .onTapGesture(perform: takePhoto)
                        Spacer()
                        Text("Select from library")
                            .onTapGesture(perform: selectPhoto)
                    }
                    .foregroundColor(.accentColor)
                }
                Section("Name") {
                    TextField("Name", text: $name)
                }
                
            }
            .padding(.bottom)
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $uiImage, sourceType: imageSourceType)
            }
            .alert(isPresented: $showingErrorAlert){
                Alert(title: Text(errorMessage))
            }
            .navigationTitle("Add contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    saveContact()
                    dismiss()
                }
            }
            .onAppear(){
                locationFetcher.start()
            }
        }
    }
    
    func takePhoto() {
        if ImagePicker.isCameraAvailable() {
            imageSourceType = .camera
            showingImagePicker = true
        }
        else {
            errorMessage = "Camera is not available"
            showingErrorAlert = true
        }
    }
    
    func selectPhoto() {
        imageSourceType = .library
        showingImagePicker = true
    }
    
    func loadImage() {
        guard let uiImage = uiImage else { return }
        image = Image(uiImage: uiImage)
    }
    
    func saveContact() {
        guard !name.isEmpty else {
            showingErrorAlert = true
            return
        }
        var contact = Contact(name: name)
        
        if let uiImage = uiImage {
            if let jpegImage = uiImage.jpegData(compressionQuality: 0.8) {
                contact.imagePath = jpegImage
            }
        }
        
        if let location = self.locationFetcher.lastKnownLocation {
            contact.latitude = location.latitude
            contact.longtitude = location.longitude
            contact.locationRecord = true
        } else {
            contact.locationRecord = false
        }
        
        contacts.items.append(contact)
        contacts.sort()
    }
}

struct AddContact_Previews: PreviewProvider {
    static var previews: some View {
        AddContact(contacts: Contacts())
    }
}
