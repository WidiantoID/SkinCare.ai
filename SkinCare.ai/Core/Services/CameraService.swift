import AVFoundation
import UIKit
import SwiftUI

/// Errors that can occur during camera operations
enum CameraServiceError: LocalizedError {
    case notAuthorized
    case captureSessionSetupFailed
    case noCaptureDevice
    case noPhotoData

    var errorDescription: String? {
        switch self {
        case .notAuthorized:
            return "Camera access not authorized. Please enable camera access in Settings."
        case .captureSessionSetupFailed:
            return "Failed to setup camera capture session."
        case .noCaptureDevice:
            return "No camera device available on this device."
        case .noPhotoData:
            return "Failed to capture photo data."
        }
    }
}

/// Service for managing camera capture functionality
/// Handles camera permissions, session configuration, and photo capture
final class CameraService: NSObject, ObservableObject {
    /// The capture session for managing camera input/output
    let session = AVCaptureSession()

    /// Queue for camera session operations
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    /// Output for capturing photos
    private let photoOutput = AVCapturePhotoOutput()

    /// Whether camera access has been authorized
    @Published var isAuthorized: Bool = false

    /// Requests camera access permission from the user
    func requestAccess() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            await MainActor.run { self.isAuthorized = true }
        case .notDetermined:
            let granted = await withCheckedContinuation { (c: CheckedContinuation<Bool, Never>) in
                AVCaptureDevice.requestAccess(for: .video) { c.resume(returning: $0) }
            }
            await MainActor.run { self.isAuthorized = granted }
        default:
            await MainActor.run { self.isAuthorized = false }
        }
    }

    /// Configures the camera capture session with appropriate settings
    /// - Note: This method should be called after camera access is authorized
    func configure() {
        guard isAuthorized else { return }
        sessionQueue.async { [weak self] in
            guard let self else { return }
            session.beginConfiguration()
            session.sessionPreset = .photo

            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
                ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) { session.addInput(input) }
                } catch {
                    print("Camera input error: \(error)")
                }
            }

            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }

            session.commitConfiguration()
            session.startRunning()
        }
    }

    /// Captures a photo from the current camera session
    /// - Returns: JPEG image data of the captured photo
    /// - Throws: CameraServiceError if capture fails
    func capturePhoto() async throws -> Data {
        try await withCheckedThrowingContinuation { (c: CheckedContinuation<Data, Error>) in
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            photoOutput.capturePhoto(with: settings, delegate: PhotoDelegate { data, error in
                if let error { c.resume(throwing: error); return }
                guard let data else {
                    c.resume(throwing: CameraServiceError.noPhotoData)
                    return
                }
                c.resume(returning: data)
            })
        }
    }
}

private final class PhotoDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    private let completion: (Data?, Error?) -> Void
    init(_ completion: @escaping (Data?, Error?) -> Void) { self.completion = completion }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error { completion(nil, error); return }
        completion(photo.fileDataRepresentation(), nil)
    }
}

final class CameraPreviewView: UIView {
    override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }
    var videoPreviewLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    func makeUIView(context: Context) -> CameraPreviewView {
        let v = CameraPreviewView()
        v.videoPreviewLayer.session = session
        v.videoPreviewLayer.videoGravity = .resizeAspectFill
        return v
    }
    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}
}


