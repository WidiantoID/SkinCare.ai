import Foundation

public enum AuthProvider: String, Codable {
    case apple
    case google
    case email
}

public struct AuthUser: Codable, Equatable, Identifiable {
    public let id: String
    public var email: String?
    public var displayName: String?
}

public protocol AuthProviding {
    func currentUser() async -> AuthUser?
    func signIn(with provider: AuthProvider) async throws -> AuthUser
    func signOut() async throws
}


