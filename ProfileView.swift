import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetAlert = false
    @State private var editing = false

    var body: some View {
        NavigationStack {
            VStack {
                if let profile = appState.operatorProfile {
                    Form {
                        // MARK: Header
                        Section {
                            HStack(spacing: 16) {
                                Image("NightPlinkersLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.vertical, 4)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(profile.fullName)
                                        .font(.title3).bold()
                                    Text(profile.email)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                    Text(profile.phone)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        // MARK: Preferred Contact
                        Section("Preferred Contact") {
                            Text(profile.preferredContact.label)
                        }

                        // MARK: XP and Badges
                        Section("Progress") {
                            HStack {
                                Text("XP")
                                Spacer()
                                Text("\(appState.xp)")
                                    .foregroundStyle(.green)
                            }
                            HStack(alignment: .top) {
                                Text("Badges")
                                Spacer()
                                if appState.badges.isEmpty {
                                    Text("None yet").foregroundStyle(.secondary)
                                } else {
                                    VStack(alignment: .trailing) {
                                        ForEach(Array(appState.badges), id: \.self) { badge in
                                            Text("• \(badge)")
                                        }
                                    }
                                }
                            }
                        }

                        // MARK: Edit and Reset
                        Section {
                            NavigationLink("Edit Operator Details") {
                                OperatorEditView(profile: profile) { updated in
                                    appState.operatorProfile = updated
                                }
                            }
                            Button(role: .destructive) {
                                showResetAlert = true
                            } label: {
                                Label("Reset Registration", systemImage: "trash")
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        } footer: {
                            Text("Reset removes your saved operator profile and progress, returning to the registration screen.")
                        }
                    }
                } else {
                    // fallback: show registration
                    OperatorRegistrationView()
                }
            }
            .navigationTitle("Operator Profile")
            .alert("Reset Operator?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    appState.resetOperatorProfile()
                }
            } message: {
                Text("This will erase your saved operator details and XP.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

// MARK: - Edit screen
struct OperatorEditView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var fullName: String
    @State private var phone: String
    @State private var email: String
    @State private var preferred: OperatorProfile.PreferredContact
    @State private var showInvalidAlert = false

    let onSave: (OperatorProfile) -> Void

    init(profile: OperatorProfile, onSave: @escaping (OperatorProfile) -> Void) {
        _fullName = State(initialValue: profile.fullName)
        _phone = State(initialValue: profile.phone)
        _email = State(initialValue: profile.email)
        _preferred = State(initialValue: profile.preferredContact)
        self.onSave = onSave
    }

    var body: some View {
        Form {
            Section("Contact Info") {
                TextField("Full Name", text: $fullName)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }

            Section("Preferred Contact") {
                Picker("Preferred", selection: $preferred) {
                    ForEach(OperatorProfile.PreferredContact.allCases) { method in
                        Text(method.label).tag(method)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section {
                Button("Save Changes") {
                    guard validateEmail(email) else {
                        showInvalidAlert = true
                        return
                    }
                    let updated = OperatorProfile(
                        fullName: fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                        phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
                        email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                        preferredContact: preferred
                    )
                    onSave(updated)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            }
        }
        .navigationTitle("Edit Details")
        .scrollContentBackground(.hidden)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
        .alert("Invalid Email", isPresented: $showInvalidAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please enter a valid email address.")
        }
    }

    private func validateEmail(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
}

