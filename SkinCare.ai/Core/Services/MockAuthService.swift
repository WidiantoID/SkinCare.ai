import Foundation

/// Mock authentication service for testing and development
/// Simulates user authentication without requiring actual auth providers
/// Useful for testing the UI and app flow without external dependencies
public final class MockAuthService: AuthProviding {
    // MARK: - Configuration

    /// Simulates network delay to make the experience more realistic
    private let simulatedDelay: TimeInterval

    /// Whether to occasionally simulate errors for testing error handling
    private let shouldSimulateErrors: Bool

    // MARK: - State

    private var user: AuthUser?

    // MARK: - Mock Data

    private let mockUsers = [
        ("demo@example.com", "Demo User"),
        ("test@example.com", "Test User"),
        ("sarah@example.com", "Sarah Johnson"),
        ("mike@example.com", "Mike Chen"),
        ("alex@example.com", "Alex Rodriguez")
    ]

    // MARK: - Initialization

    /// Creates a new mock auth service
    /// - Parameters:
    ///   - simulatedDelay: How long to wait before returning results (default: 1 second)
    ///   - shouldSimulateErrors: Whether to occasionally throw errors for testing (default: false)
    public init(simulatedDelay: TimeInterval = 1.0, shouldSimulateErrors: Bool = false) {
        self.simulatedDelay = simulatedDelay
        self.shouldSimulateErrors = shouldSimulateErrors
        AppLogger.info("MockAuthService initialized with \(simulatedDelay)s delay", category: .auth)
    }

    // MARK: - AuthProviding Protocol

    public func currentUser() async -> AuthUser? {
        AppLogger.debug("MockAuthService: Checking current user", category: .auth)
        return user
    }

    public func signIn(with provider: AuthProvider) async throws -> AuthUser {
        AppLogger.info("MockAuthService: Starting sign in with \(provider)", category: .auth)

        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))

        // Occasionally simulate errors if configured
        if shouldSimulateErrors && Double.random(in: 0...1) < 0.15 {
            AppLogger.warning("MockAuthService: Simulating sign in error for testing", category: .auth)
            throw NSError(
                domain: "MockAuthServiceError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Simulated authentication error for testing purposes"]
            )
        }

        // Select random user credentials
        let (email, displayName) = mockUsers.randomElement() ?? mockUsers[0]

        let newUser = AuthUser(
            id: UUID().uuidString,
            email: email,
            displayName: displayName
        )

        user = newUser
        AppLogger.info("MockAuthService: Sign in successful for \(email)", category: .auth)

        return newUser
    }

    public func signOut() async throws {
        AppLogger.info("MockAuthService: Starting sign out", category: .auth)

        // Simulate network delay
        try await Task.sleep(nanoseconds: UInt64(simulatedDelay * 1_000_000_000))

        // Occasionally simulate errors if configured
        if shouldSimulateErrors && Double.random(in: 0...1) < 0.1 {
            AppLogger.warning("MockAuthService: Simulating sign out error for testing", category: .auth)
            throw NSError(
                domain: "MockAuthServiceError",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Simulated sign out error for testing purposes"]
            )
        }

        user = nil
        AppLogger.info("MockAuthService: Sign out successful", category: .auth)
    }

    // MARK: - Helper Methods

    /// Manually sets the current user (useful for testing specific scenarios)
    /// - Parameter user: The user to set as current
    public func setCurrentUser(_ user: AuthUser?) {
        self.user = user
        if let user = user {
            AppLogger.debug("MockAuthService: Manually set current user to \(user.email)", category: .auth)
        } else {
            AppLogger.debug("MockAuthService: Manually cleared current user", category: .auth)
        }
    }
}
