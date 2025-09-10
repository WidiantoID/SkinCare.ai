import Foundation
import Vision

public final class VisionFaceDetector: FaceDetecting {
    public init() {}

    public func detectFaces(in imageData: Data) async throws -> [FaceBoundingBox] {
        let handler = VNImageRequestHandler(data: imageData, options: [:])
        let request = VNDetectFaceRectanglesRequest()
        try handler.perform([request])
        let observations: [VNFaceObservation] = request.results ?? []
        return observations.map { FaceBoundingBox(rect: $0.boundingBox) }
    }
}


