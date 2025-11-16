import Foundation
import SwiftUI

/// Centralized user data manager
/// - Note: All user data is persisted to UserDefaults
@MainActor
class UserData: ObservableObject {
    // MARK: - Published Properties

    /// User's display name
    @Published var name: String = "" {
        didSet { saveUserData() }
    }

    /// User's age as string
    @Published var age: String = "" {
        didSet { saveUserData() }
    }

    /// User's skin type
    @Published var skinType: String = "" {
        didSet { saveUserData() }
    }

    /// User's skincare goals
    @Published var goals: [String] = [] {
        didSet { saveUserData() }
    }

    /// Whether user has completed onboarding
    @Published var hasCompletedOnboarding: Bool = false {
        didSet { saveUserData() }
    }

    /// Member since date
    @Published var memberSince: Date = Date() {
        didSet { saveUserData() }
    }

    // MARK: - Singleton

    static let shared = UserData()

    private init() {
        loadUserData()
    }

    // MARK: - Public Methods

    /// Updates user information
    /// - Parameters:
    ///   - name: User's name
    ///   - age: User's age
    func updateUserInfo(name: String, age: String) {
        self.name = name
        self.age = age
        self.hasCompletedOnboarding = true
        // Don't call saveUserData() here as didSet will handle it
    }

    /// Updates profile information
    /// - Parameters:
    ///   - name: User's display name
    ///   - age: User's age
    ///   - skinType: User's skin type
    ///   - goals: User's skincare goals
    func updateProfile(name: String, age: String, skinType: String, goals: [String]) {
        self.name = name
        self.age = age
        self.skinType = skinType
        self.goals = goals
    }

    /// Clears all user data
    func clearUserData() {
        name = ""
        age = ""
        skinType = ""
        goals = []
        hasCompletedOnboarding = false
        memberSince = Date()
    }

    // MARK: - Computed Properties

    /// User's age as integer
    var ageInt: Int? {
        Int(age)
    }

    /// Whether the age is valid (13-100)
    var isValidAge: Bool {
        guard let ageValue = ageInt else { return false }
        return ageValue >= 13 && ageValue <= 100
    }

    /// Formatted member since string
    var memberSinceFormatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: memberSince)
    }

    // MARK: - Persistence

    private func saveUserData() {
        UserDefaults.standard.set(name, forKey: "user_name")
        UserDefaults.standard.set(age, forKey: "user_age")
        UserDefaults.standard.set(skinType, forKey: "user_skin_type")
        UserDefaults.standard.set(goals, forKey: "user_goals")
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "has_completed_onboarding")
        UserDefaults.standard.set(memberSince.timeIntervalSince1970, forKey: "user_member_since")
    }

    private func loadUserData() {
        name = UserDefaults.standard.string(forKey: "user_name") ?? ""
        age = UserDefaults.standard.string(forKey: "user_age") ?? ""
        skinType = UserDefaults.standard.string(forKey: "user_skin_type") ?? "Combination"
        goals = UserDefaults.standard.array(forKey: "user_goals") as? [String] ?? []
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")

        let memberSinceTimestamp = UserDefaults.standard.double(forKey: "user_member_since")
        if memberSinceTimestamp > 0 {
            memberSince = Date(timeIntervalSince1970: memberSinceTimestamp)
        } else {
            memberSince = Date()
            saveUserData() // Save the initial date
        }
    }
}
