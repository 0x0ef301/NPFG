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

/// A reusable media intake sheet supporting:
/// - photo camera
/// - video camera
/// - photo picker
/// Saves results via MediaManager + creates NPMediaItem records.
struct MediaCaptureView: View {

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    /// Called whenever a new NPMediaItem has been created & saved.
    var onSaved: ((NPMediaItem) -> Void)? = nil

    // MARK: UI State

    @State private var showPhotoCamera = false
    @State private var showVideoCamera = false
    @State private var pickerItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 20) {

            Text("Add Media")
                .font(.title2.bold())
                .foregroundColor(.white)

            // MARK: Take Photo
            Button {
                showPhotoCamera = true
            } label: {
                bigButtonLabel("Take Photo", system: "camera")
            }

            // MARK: Record Video
            Button {
                showVideoCamera = true
            } label: {
                bigButtonLabel("Record Video", system: "video")
            }

            // MARK: Choose from Library
            PhotosPicker(
                selection: $pickerItem,
                matching: .images
            ) {
                bigButtonLabel("Choose Photo from Library", system: "photo")
            }

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

        // MARK: Library Change
        .onChange(of: pickerItem) { _, newItem in
            Task { await processPickerItem(newItem) }
        }
    }

    // ============================================================
    // MARK: - UI Helper
    // ============================================================
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
    // MARK: - Camera Result Processor
    // ============================================================
    private func handleCameraResult(_ result: CameraOutput) {
        switch result {
        case .photo(let image):
            savePhoto(image)
        case .video(let url):
            saveVideo(url)
        case .cancelled:
            break
        }
    }

    // ============================================================
    // MARK: - Save Photo
    // ============================================================
    private func savePhoto(_ image: UIImage) {
        guard let path = MediaManager.shared.savePhoto(image, originalName: "photo") else { return }
        storeMediaRecord(path: path, type: .photo)
    }

    // ============================================================
    // MARK: - Save Video
    // ============================================================
    private func saveVideo(_ url: URL) {
        guard let path = MediaManager.shared.saveVideo(from: url, originalName: "video") else { return }
        storeMediaRecord(path: path, type: .video)
    }

    // ============================================================
    // MARK: - SwiftData Create Record
    // ============================================================
    private func storeMediaRecord(path: String, type: MediaType) {
        let filename = (path as NSString).lastPathComponent

        let item = NPMediaItem(
            type: type,
            originalFileName: filename,
            filePath: path,
            note: nil,
            field: nil        // will be associated outside
        )

        context.insert(item)

        do {
            try context.save()
        } catch {
            print("❌ Failed to save NPMediaItem:", error)
        }

        onSaved?(item)
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
}

//
//  MediaManager extension to support savePhoto / saveVideo
//
extension MediaManager {

    /// Directory where we store media files for Night Plinkers.
    private var mediaDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaDir = docs.appendingPathComponent("Media", isDirectory: true)

        if !FileManager.default.fileExists(atPath: mediaDir.path) {
            try? FileManager.default.createDirectory(at: mediaDir, withIntermediateDirectories: true)
        }
        return mediaDir
    }

    /// Save a UIImage as JPEG and return the full file path string.
    func savePhoto(_ image: UIImage, originalName: String) -> String? {
        let filename = "\(originalName)_\(UUID().uuidString).jpg"
        let url = mediaDirectory.appendingPathComponent(filename)

        guard let data = image.jpegData(compressionQuality: 0.9) else { return nil }

        do {
            try data.write(to: url, options: .atomic)
            return url.path
        } catch {
            print("❌ Failed to write photo:", error)
            return nil
        }
    }

    /// Copy a video file into the media directory and return full file path.
    func saveVideo(from sourceURL: URL, originalName: String) -> String? {
        let filename = "\(originalName)_\(UUID().uuidString).mov"
        let destURL = mediaDirectory.appendingPathComponent(filename)

        do {
            // In case reusing same name, remove existing
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
            return destURL.path
        } catch {
            print("❌ Failed to copy video:", error)
            return nil
        }
    }
}

