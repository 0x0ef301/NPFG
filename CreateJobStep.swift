import SwiftUI

struct CreateJobStep: View {
    @State private var clientName = ""
    @State private var clientEmail = ""
    @State private var propertyNickname = ""
    @State private var address = ""
    let onNext: () -> Void

    var body: some View {
        Form {
            Section("Client") {
                TextField("Name", text: $clientName)
                TextField("Email", text: $clientEmail)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            Section("Property") {
                TextField("Nickname", text: $propertyNickname)
                TextField("Address", text: $address)
            }
            Section {
                Button("Save & Continue") {
                    // For now, just log to the console.
                    print("Saved draft job: \(clientName) @ \(propertyNickname) — \(address)")
                    onNext()
                }
                .disabled(clientName.isEmpty || propertyNickname.isEmpty)
            }
        }
    }
}