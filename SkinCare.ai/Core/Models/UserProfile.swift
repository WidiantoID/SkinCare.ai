import Foundation

public struct UserProfile: Codable, Equatable, Identifiable {
    public let id: UUID
    public var displayName: String
    public var age: Int?
    public var gender: String?
    public var skinType: String?
    public var goals: [String]

    public init(
        id: UUID = UUID(),
        displayName: String,
        age: Int? = nil,
        gender: String? = nil,
        skinType: String? = nil,
        goals: [String] = []
    ) {
        self.id = id
        self.displayName = displayName
        self.age = age
        self.gender = gender
        self.skinType = skinType
        self.goals = goals
    }
}


