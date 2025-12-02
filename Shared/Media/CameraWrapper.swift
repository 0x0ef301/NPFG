//
//  CameraWrapper.swift
//  NPFG
//
//  Created by Eric Stewart on 11/29/25.
//

import SwiftUI
import AVFoundation

enum CameraOutput {
    case photo(UIImage)
    case video(URL)
    case cancelled
}

enum CameraMode {
    case photo
    case video
}

/// UIViewControllerRepresentable wrapper for camera.
struct CameraWrapper: UIViewControllerRepresentable {

    let mode: CameraMode
    let onCapture: (CameraOutput) -> Void

    func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()
        vc.mode = mode
        vc.onCapture = onCapture
        return vc
    }

    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {}
}

// MARK: - UIKit Camera VC
final class CameraViewController: UIViewController,
    AVCapturePhotoCaptureDelegate,
    AVCaptureFileOutputRecordingDelegate
{
    var onCapture: ((CameraOutput) -> Void)?
    var mode: CameraMode = .photo

    private let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureMovieFileOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
    }

    private func setupCamera() {
        session.beginConfiguration()

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            onCapture?(.cancelled)
            return
        }

        if session.canAddInput(input) { session.addInput(input) }

        switch mode {
        case .photo:
            if session.canAddOutput(photoOutput) { session.addOutput(photoOutput) }
        case .video:
            if session.canAddOutput(videoOutput) { session.addOutput(videoOutput) }
        }

        session.commitConfiguration()
        session.startRunning()

        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.frame = view.bounds
        preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(preview)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.begin()
        }
    }

    private func begin() {
        switch mode {
        case .photo:
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)

        case .video:
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("\(UUID().uuidString).mov")
            videoOutput.startRecording(to: url, recordingDelegate: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.videoOutput.stopRecording()
            }
        }
    }

    // MARK: Photo Delegate
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        session.stopRunning()

        guard let data = photo.fileDataRepresentation(),
              let img = UIImage(data: data)
        else {
            onCapture?(.cancelled)
            return
        }

        onCapture?(.photo(img))
    }

    // MARK: Video Delegate
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {

        session.stopRunning()

        if let err = error {
            print("Video recording error:", err)
            onCapture?(.cancelled)
            return
        }

        onCapture?(.video(outputFileURL))
    }
}
