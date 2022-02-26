import SwiftUI

struct ContentView: View {
    @StateObject var contacts = Contacts()
    
    @State private var showingImagePicker = false
    var body: some View {
        NavigationView {
            List{
                ForEach(contacts.items) { contact in
                    NavigationLink(destination: DetailView(contact: contact)) {
                        if let imageData = contact.imagePath {
                            Image(uiImage: UIImage(data: imageData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(10)
                                .foregroundColor(.gray)
                        }
                        Text(contact.name)
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("Event contacts")
            .navigationBarItems(
                leading: EditButton(),
                trailing: 
                    Button{
                        showingImagePicker = true
                    } label: {
                        Image(systemName: "plus")
                    }
            )
            .sheet(isPresented: $showingImagePicker) {
                AddContact(contacts: contacts)
            }
        }
    }
    func removeItems(at offsets: IndexSet){
        contacts.items.remove(atOffsets: offsets)
    }
}
