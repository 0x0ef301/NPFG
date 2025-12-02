//
//  MediaCaptureView.swift
//  NPFG
//
//  Created by Eric Stewart on 11/30/25.
//

import SwiftUI
import PhotosUI
import SwiftData
import AVFoundation
import UIKit

/// A reusable media intake sheet supporting capture and library attachments.
struct MediaCaptureView: View {

    enum Mode {
        case photo
        case video
        case audio
        case library
    }

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Bindable var field: NPJobFormFieldInstance
    let mode: Mode

    /// Called after the media item has been persisted so the parent can refresh.
    var onSave: (() -> Void)? = nil

    // MARK: UI State

    @State private var showPhotoCamera = false
    @State private var showVideoCamera = false
    @State private var showLibraryPicker = false
    @State private var pickerItem: PhotosPickerItem? = nil

    @State private var isRecording = false
    @State private var recorder: AVAudioRecorder?
    @State private var tempAudioURL: URL?

    var body: some View {
        VStack(spacing: 20) {

            Text(headerTitle)
                .font(.title2.bold())
                .foregroundColor(.white)

            modeSpecificControls

            Spacer()
        }
        .padding()
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)

        // MARK: Photo Camera Sheet
        .sheet(isPresented: $showPhotoCamera) {
            CameraWrapper(mode: .photo) { result in
                handleCameraResult(result)
            }
        }

        // MARK: Video Camera Sheet
        .sheet(isPresented: $showVideoCamera) {
            CameraWrapper(mode: .video) { result in
                handleCameraResult(result)
            }
        }

        // MARK: Library Picker
        .photosPicker(isPresented: $showLibraryPicker,
                      selection: $pickerItem,
                      matching: .images) { EmptyView() }
        .onChange(of: pickerItem) { _, newItem in
            Task { await processPickerItem(newItem) }
        }
        .onAppear { triggerModePresentation() }
    }

    // ============================================================
    // MARK: - UI Helpers
    // ============================================================
    private var headerTitle: String {
        switch mode {
        case .photo: return "Capture Photo"
        case .video: return "Capture Video"
        case .audio: return "Record Audio"
        case .library: return "Attach from Library"
        }
    }

    @ViewBuilder
    private var modeSpecificControls: some View {
        switch mode {
        case .photo:
            VStack(spacing: 12) {
                Text("Launching camera…")
                    .foregroundColor(.gray)
                Button {
                    showPhotoCamera = true
                } label: {
                    bigButtonLabel("Open Camera", system: "camera")
                }
            }

        case .video:
            VStack(spacing: 12) {
                Text("Launching video recorder…")
                    .foregroundColor(.gray)
                Button {
                    showVideoCamera = true
                } label: {
                    bigButtonLabel("Open Video Camera", system: "video")
                }
            }

        case .library:
            PhotosPicker(
                selection: $pickerItem,
                matching: .images
            ) {
                bigButtonLabel("Choose Photo from Library", system: "photo.on.rectangle")
            }

        case .audio:
            VStack(spacing: 16) {
                Button {
                    isRecording ? stopRecording() : startRecording()
                } label: {
                    bigButtonLabel(isRecording ? "Stop Recording" : "Start Recording",
                                   system: isRecording ? "stop.circle" : "waveform")
                }

                if isRecording {
                    Text("Recording…")
                        .foregroundColor(.green)
                }
            }
        }
    }

    private func bigButtonLabel(_ title: String, system: String) -> some View {
        Label {
            Text(title)
                .font(.headline)
        } icon: {
            Image(systemName: system)
                .font(.title2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green.opacity(0.3))
        .cornerRadius(12)
        .foregroundColor(.white)
    }

    // ============================================================
    // MARK: - Mode Handling
    // ============================================================
    private func triggerModePresentation() {
        switch mode {
        case .photo:
            showPhotoCamera = true
        case .video:
            showVideoCamera = true
        case .library:
            showLibraryPicker = true
        case .audio:
            break
        }
    }

    // ============================================================
    // MARK: - Camera Result Processor
    // ============================================================
    private func handleCameraResult(_ result: CameraOutput) {
        switch result {
        case .photo(let image):
            savePhoto(image)
        case .video(let url):
            saveVideo(url)
        case .cancelled:
            dismiss()
        }
    }

    // ============================================================
    // MARK: - Save Helpers
    // ============================================================
    private func savePhoto(_ image: UIImage) {
        guard let path = MediaManager.shared.savePhoto(image, originalName: "photo") else { return }
        storeMediaRecord(path: path, type: .photo)
    }

    private func saveVideo(_ url: URL) {
        guard let path = MediaManager.shared.saveVideo(from: url, originalName: "video") else { return }
        storeMediaRecord(path: path, type: .video)
    }

    private func saveAudio(_ url: URL) {
        guard let path = MediaManager.shared.saveAudio(from: url, originalName: "audio") else { return }
        storeMediaRecord(path: path, type: .audio)
    }

    private func storeMediaRecord(path: String, type: MediaType) {
        let filename = (path as NSString).lastPathComponent

        let item = NPMediaItem(
            type: type,
            originalFileName: filename,
            filePath: path,
            note: nil,
            field: field
        )

        field.mediaItems.append(item)
        context.insert(item)

        do {
            try context.save()
            onSave?()
        } catch {
            print("❌ Failed to save NPMediaItem:", error)
        }

        dismiss()
    }

    // ============================================================
    // MARK: - Photo Picker
    // ============================================================
    private func processPickerItem(_ item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                savePhoto(image)
            }
        } catch {
            print("❌ Failed processing picker item:", error)
        }
    }

    // ============================================================
    // MARK: - Audio Recording
    // ============================================================
    private func startRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            print("❌ Unable to start audio session:", error)
            return
        }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString).m4a")

        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            tempAudioURL = url
            isRecording = true
        } catch {
            print("❌ Unable to start recording:", error)
        }
    }

    private func stopRecording() {
        recorder?.stop()
        isRecording = false

        guard let url = tempAudioURL else {
            dismiss()
            return
        }

        saveAudio(url)
    }
}
