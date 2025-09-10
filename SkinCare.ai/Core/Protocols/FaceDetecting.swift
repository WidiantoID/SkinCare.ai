import Foundation
import CoreGraphics

public struct FaceBoundingBox: Codable, Equatable, Identifiable {
    public let id: UUID
    public let rect: CGRect

    public init(id: UUID = UUID(), rect: CGRect) {
        self.id = id
        self.rect = rect
    }
}

public protocol FaceDetecting {
    func detectFaces(in imageData: Data) async throws -> [FaceBoundingBox]
}


