//
//  OperatorRegistrationView.swift
//  NPFG
//
//  Created by Eric Stewart on 10/21/25.
//

import SwiftUI

struct OperatorRegistrationView: View {
    @EnvironmentObject var appState: AppState

    @State private var fullName = ""
    @State private var phone = ""
    @State private var email = ""
    @State private var preferred = OperatorProfile.PreferredContact.phone

    @State private var showInvalidAlert = false
    @FocusState private var focusedField: Field?

    enum Field { case name, phone, email }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Image("NightPlinkersLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .padding(.trailing, 8)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Night Plinkers")
                                .font(.title2).bold()
                            Text("Operator Registration")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listRowBackground(Color.black)
                }

                Section("Contact Details") {
                    TextField("Full name", text: $fullName)
                        .focused($focusedField, equals: .name)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .phone }

                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                        .focused($focusedField, equals: .phone)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .email }

                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .focused($focusedField, equals: .email)
                }

                Section("Preferred Contact Method") {
                    Picker("Preferred", selection: $preferred) {
                        ForEach(OperatorProfile.PreferredContact.allCases) { opt in
                            Text(opt.label).tag(opt)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section {
                    Button {
                        if validate() {
                            let profile = OperatorProfile(
                                fullName: fullName.trimmingCharacters(in: .whitespacesAndNewlines),
                                phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
                                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                preferredContact: preferred
                            )
                            appState.operatorProfile = profile
                        } else {
                            showInvalidAlert = true
                        }
                    } label: {
                        Text("Save & Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .disabled(fullName.isEmpty || email.isEmpty)
                } footer: {
                    Text("We use your info on forms, signatures, and reports.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Operator")
            .alert("Please check your details", isPresented: $showInvalidAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Enter a valid email (e.g., name@domain.com).")
            }
        }
        .preferredColorScheme(.dark)
    }

    private func validate() -> Bool {
        email.contains("@") && email.contains(".")
    }
}
