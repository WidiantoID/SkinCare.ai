import Foundation
import SwiftUI

@MainActor
class UserData: ObservableObject {
    @Published var name: String = ""
    @Published var age: String = ""
    @Published var hasCompletedOnboarding: Bool = false
    
    static let shared = UserData()
    
    private init() {
        loadUserData()
    }
    
    func updateUserInfo(name: String, age: String) {
        self.name = name
        self.age = age
        self.hasCompletedOnboarding = true
        saveUserData()
    }
    
    func clearUserData() {
        name = ""
        age = ""
        hasCompletedOnboarding = false
        saveUserData()
    }
    
    private func saveUserData() {
        UserDefaults.standard.set(name, forKey: "user_name")
        UserDefaults.standard.set(age, forKey: "user_age")
        UserDefaults.standard.set(hasCompletedOnboarding, forKey: "has_completed_onboarding")
    }
    
    private func loadUserData() {
        name = UserDefaults.standard.string(forKey: "user_name") ?? ""
        age = UserDefaults.standard.string(forKey: "user_age") ?? ""
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "has_completed_onboarding")
    }
    
    var ageInt: Int? {
        Int(age)
    }
    
    var isValidAge: Bool {
        guard let ageValue = ageInt else { return false }
        return ageValue >= 13 && ageValue <= 100
    }
}
