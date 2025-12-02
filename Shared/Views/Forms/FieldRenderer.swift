//
//  FieldRenderer.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import SwiftUI
import SwiftData

enum FieldType: String {
    case text
    case number
    case photo
    case video
    case audio
    case media
}

struct FieldRenderer: View {

    @Environment(\.modelContext) private var context
    @EnvironmentObject var mediaManager: MediaManager

    // The specific field instance for THIS job + THIS form
    @Bindable var field: NPJobFormFieldInstance

    // Media sheet toggles
    @State private var showPhotoCapture = false
    @State private var showVideoCapture = false
    @State private var showAudioCapture = false
    @State private var showLibraryPicker = false

    // UI
    private let cardColor = Color(.secondarySystemBackground)
    private let accent = Color.green.opacity(0.85)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // MARK: FIELD LABEL
            Text(field.label)
                .font(.headline)
                .foregroundColor(.white)

            // MARK: FIELD CONTENT
            switch field.fieldType {
            case .text:
                textFieldCard()

            case .number:
                numberFieldCard()

            case .photo, .video, .audio, .media:
                mediaFieldCard()

            }
        }
        .padding(.vertical, 8)
    }
}

// ================================================================
// MARK: - UI COMPONENTS
// ================================================================
extension FieldRenderer {

    // MARK: TEXT FIELD
    @ViewBuilder
    private func textFieldCard() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            TextField("Enter text…", text: $field.value.boundDefault)
                .padding(10)
                .background(cardColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(accent, lineWidth: 1)
                )
                .foregroundColor(.white)
                .onChange(of: field.value) { _, _ in save() }
        }
    }

    // MARK: NUMBER FIELD
    @ViewBuilder
    private func numberFieldCard() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            TextField("Enter number…",
                      text: $field.value.boundDefault)
                .keyboardType(.numberPad)
                .padding(10)
                .background(cardColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(accent, lineWidth: 1)
                )
                .foregroundColor(.white)
                .onChange(of: field.value) { _, _ in save() }
        }
    }

    // MARK: MEDIA FIELD
    @ViewBuilder
    private func mediaFieldCard() -> some View {

        VStack(alignment: .leading, spacing: 12) {

            // MEDIA BUTTON ROW
            HStack(spacing: 16) {

                mediaIcon("camera", action: { showPhotoCapture = true })
                mediaIcon("video", action: { showVideoCapture = true })
                mediaIcon("waveform", action: { showAudioCapture = true })
                mediaIcon("photo.on.rectangle", action: { showLibraryPicker = true })

            }

            // MEDIA THUMBNAIL SCROLLER
            if !field.mediaItems.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(field.mediaItems) { item in
                            mediaThumbnail(item)
                        }
                    }
                }
            }
        }

        // CAPTURE SHEETS
        .sheet(isPresented: $showPhotoCapture) {
            MediaCaptureView(mode: .photo, field: field, onSave: save)
        }
        .sheet(isPresented: $showVideoCapture) {
            MediaCaptureView(mode: .video, field: field, onSave: save)
        }
        .sheet(isPresented: $showAudioCapture) {
            MediaCaptureView(mode: .audio, field: field, onSave: save)
        }
        .sheet(isPresented: $showLibraryPicker) {
            MediaCaptureView(mode: .library, field: field, onSave: save)
        }
    }

    // MARK: MEDIA ICON
    private func mediaIcon(_ system: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: system)
                .font(.title2)
                .foregroundColor(accent)
                .frame(width: 44, height: 44)
                .background(Color.black)
                .clipShape(Circle())
                .overlay(Circle().stroke(accent, lineWidth: 1))
        }
    }

    // MARK: THUMBNAIL
    @ViewBuilder
    private func mediaThumbnail(_ item: NPMediaItem) -> some View {
        Group {
            if let ui = mediaManager.thumbnail(for: item) {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(Image(systemName: "questionmark").foregroundColor(.white))
            }
        }
        .frame(width: 70, height: 70)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(accent.opacity(0.7), lineWidth: 1)
        )
    }
}

// ================================================================
// MARK: - SAVE HANDLER
// ================================================================
extension FieldRenderer {
    private func save() {
        field.section?.form?.updateTimestamp()
        try? context.save()
    }
}

// ================================================================
// MARK: - FIELD TYPE HELPERS
// ================================================================
extension NPJobFormFieldInstance {
    var fieldType: FieldType {
        // First try to map directly to a FieldType raw value
        if let direct = FieldType(rawValue: typeRaw) {
            return direct
        }

        // Fallback: map template field types to renderable field types
        if let templateType = NPFormFieldTemplate.FieldType(rawValue: typeRaw) {
            switch templateType {
            case .text: return .text
            case .number: return .number
            case .checkbox, .date, .time, .yesNo, .location, .signature:
                return .text
            case .mediaNote:
                return .media
            }
        }

        return .text
    }
}

// Convenience to avoid nil binding issues
extension Optional where Wrapped == String {
    var boundDefault: String {
        get { self ?? "" }
        set { self = newValue }
    }
}

