import Foundation
import Vision

/// Face detection service using Apple's Vision framework
/// Detects faces in images and validates image quality for skin analysis
public final class VisionFaceDetector: FaceDetecting {
    // MARK: - Error Types

    /// Errors that can occur during face detection
    public enum FaceDetectionError: LocalizedError {
        case noFacesDetected
        case multipleFacesDetected
        case imageTooBlurry
        case poorLighting
        case faceNotCentered
        case faceTooSmall
        case visionFrameworkError(Error)

        public var errorDescription: String? {
            switch self {
            case .noFacesDetected:
                return "No face detected in the image. Please ensure your face is clearly visible."
            case .multipleFacesDetected:
                return "Multiple faces detected. Please ensure only one face is in the frame."
            case .imageTooBlurry:
                return "Image is too blurry. Please capture a clearer photo."
            case .poorLighting:
                return "Poor lighting detected. Please use better lighting for accurate analysis."
            case .faceNotCentered:
                return "Face is not centered in the image. Please position your face in the center."
            case .faceTooSmall:
                return "Face is too small in the image. Please move closer to the camera."
            case .visionFrameworkError(let error):
                return "Face detection failed: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - Initialization

    public init() {}

    // MARK: - Face Detection

    public func detectFaces(in imageData: Data) async throws -> [FaceBoundingBox] {
        AppLogger.debug("Starting face detection", category: .camera)

        do {
            let handler = VNImageRequestHandler(data: imageData, options: [:])
            let request = VNDetectFaceRectanglesRequest()

            try handler.perform([request])

            let observations: [VNFaceObservation] = request.results ?? []

            if observations.isEmpty {
                AppLogger.warning("No faces detected in image", category: .camera)
                throw FaceDetectionError.noFacesDetected
            }

            AppLogger.info("Detected \(observations.count) face(s)", category: .camera)

            return observations.map { FaceBoundingBox(rect: $0.boundingBox) }
        } catch let error as FaceDetectionError {
            throw error
        } catch {
            AppLogger.error("Vision framework error during face detection", error: error, category: .camera)
            throw FaceDetectionError.visionFrameworkError(error)
        }
    }

    // MARK: - Face Quality Validation

    /// Validates that exactly one face is present and properly positioned
    /// - Parameter imageData: The image data to validate
    /// - Throws: FaceDetectionError if validation fails
    /// - Returns: The detected face bounding box if validation succeeds
    public func validateSingleFace(in imageData: Data) async throws -> FaceBoundingBox {
        let faces = try await detectFaces(in: imageData)

        guard faces.count == 1 else {
            if faces.count > 1 {
                AppLogger.warning("Multiple faces detected: \(faces.count)", category: .camera)
                throw FaceDetectionError.multipleFacesDetected
            } else {
                throw FaceDetectionError.noFacesDetected
            }
        }

        let face = faces[0]

        // Validate face size (should be at least 20% of image area)
        let faceArea = face.rect.width * face.rect.height
        if faceArea < 0.2 {
            AppLogger.warning("Face too small in frame: \(String(format: "%.1f%%", faceArea * 100))", category: .camera)
            throw FaceDetectionError.faceTooSmall
        }

        // Validate face is reasonably centered (within middle 80% of image)
        let centerX = face.rect.midX
        let centerY = face.rect.midY
        if centerX < 0.2 || centerX > 0.8 || centerY < 0.2 || centerY > 0.8 {
            AppLogger.warning("Face not centered: (\(String(format: "%.2f", centerX)), \(String(format: "%.2f", centerY)))", category: .camera)
            throw FaceDetectionError.faceNotCentered
        }

        AppLogger.info("Face validation passed", category: .camera)
        return face
    }

    // MARK: - Helper Methods

    /// Checks if the image contains exactly one face
    /// - Parameter imageData: The image data to check
    /// - Returns: True if exactly one face is detected
    public func hasSingleFace(in imageData: Data) async -> Bool {
        do {
            let faces = try await detectFaces(in: imageData)
            return faces.count == 1
        } catch {
            AppLogger.debug("Face detection check failed: \(error.localizedDescription)", category: .camera)
            return false
        }
    }

    /// Returns the number of faces detected in the image
    /// - Parameter imageData: The image data to analyze
    /// - Returns: The number of faces detected, or 0 if detection fails
    public func faceCount(in imageData: Data) async -> Int {
        do {
            let faces = try await detectFaces(in: imageData)
            return faces.count
        } catch {
            AppLogger.debug("Face count check failed: \(error.localizedDescription)", category: .camera)
            return 0
        }
    }
}
