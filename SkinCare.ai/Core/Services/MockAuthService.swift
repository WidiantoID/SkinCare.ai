import Foundation

public final class MockAuthService: AuthProviding {
    private var user: AuthUser?

    public init() {}

    public func currentUser() async -> AuthUser? {
        user
    }

    public func signIn(with provider: AuthProvider) async throws -> AuthUser {
        let newUser = AuthUser(id: UUID().uuidString, email: "demo@example.com", displayName: "Demo User")
        user = newUser
        return newUser
    }

    public func signOut() async throws {
        user = nil
    }
}


