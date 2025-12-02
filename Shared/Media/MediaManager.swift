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

    // MARK: - File Deletion
    func deleteFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Delete error: \(error)")
        }
    }
}

