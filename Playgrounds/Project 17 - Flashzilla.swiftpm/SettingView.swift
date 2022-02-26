import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var retryIncorrectCards: Bool
    
    var body: some View {
        NavigationView{
            Form{
                Toggle("Retry incorrect cards", isOn: $retryIncorrectCards)
            }
                .navigationTitle("Settings")
                .toolbar{
                    Button("Done") {
                        dismiss()
                    }
                }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(retryIncorrectCards: Binding.constant(false))
    }
}
