//
//  MediaManager.swift
//  NPFG
//
//  Guaranteed FIX for:
//  “Type 'MediaManager' does not conform to protocol 'ObservableObject'”
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import Combine   // ← REQUIRED FOR ObservableObject stability

class MediaManager: ObservableObject {

    // This forces ObservableObject synthesis (Xcode bug workaround)
    @Published var lastUpdated: Date = Date()

    static let shared = MediaManager()

    private init() { }

    // MARK: - Storage Location
    private var mediaDirectory: URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mediaDir = docs.appendingPathComponent("Media", isDirectory: true)

        if !FileManager.default.fileExists(atPath: mediaDir.path) {
            try? FileManager.default.createDirectory(at: mediaDir, withIntermediateDirectories: true)
        }
        return mediaDir
    }

    // MARK: - Photo Loading
    func loadPhoto(at url: URL) -> UIImage? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }

    // MARK: - Video Thumbnail Loading
    func loadVideoThumbnail(at url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true

        do {
            let cgImage = try generator.copyCGImage(
                at: CMTime(seconds: 0.2, preferredTimescale: 600),
                actualTime: nil
            )
            return UIImage(cgImage: cgImage)
        } catch {
            print("Thumbnail generation error: \(error)")
            return nil
        }
    }

    // MARK: - Media Saving
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

    // MARK: - Audio Playback Support
    private var audioPlayer: AVAudioPlayer?

    func playAudio(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Audio playback error: \(error)")
        }
    }

    func stopAudio() {
        audioPlayer?.stop()
    }

    // MARK: - Audio Saving
    func saveAudio(from sourceURL: URL, originalName: String) -> String? {
        let filename = "\(originalName)_\(UUID().uuidString).m4a"
        let destURL = mediaDirectory.appendingPathComponent(filename)

        do {
            if FileManager.default.fileExists(atPath: destURL.path) {
                try FileManager.default.removeItem(at: destURL)
            }
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
            return destURL.path
        } catch {
            print("❌ Failed to save audio:", error)
            return nil
        }
    }

    // MARK: - Thumbnails
    func thumbnail(for item: NPMediaItem) -> UIImage? {
        switch item.type {
        case .photo:
            let url = URL(string: item.filePath) ?? URL(fileURLWithPath: item.filePath)
            return loadPhoto(at: url)

        case .video:
            let url = URL(string: item.filePath) ?? URL(fileURLWithPath: item.filePath)
            return loadVideoThumbnail(at: url)

        case .audio:
            return UIImage(systemName: "waveform.circle.fill")
        }
    }

    // MARK: - File Deletion
    func deleteFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Delete error: \(error)")
        }
    }
}

