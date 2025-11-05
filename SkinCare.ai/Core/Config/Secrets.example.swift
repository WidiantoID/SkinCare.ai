import Foundation

/// Configuration for secure API keys and secrets
/// - Important: Never commit actual API keys to version control
/// - Use environment variables or Xcode configuration for secure key storage
///
/// INSTRUCTIONS:
/// 1. Copy this file to Secrets.swift in the same directory
/// 2. Add your actual API key to the Secrets.swift file
/// 3. Secrets.swift is gitignored and will not be committed
enum Secrets {
    /// Gemini API key for AI-powered skin analysis
    /// - Returns: API key from environment variable or nil if not configured
    /// - Note: Set GEMINI_API_KEY environment variable or use Xcode build configuration
    static let geminiApiKey: String? = {
        // Try to get from environment variable first (recommended for production)
        if let env = ProcessInfo.processInfo.environment["GEMINI_API_KEY"], !env.isEmpty {
            return env
        }

        // Try to get from Xcode build configuration
        if let configKey = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String, !configKey.isEmpty {
            return configKey
        }

        // OPTION 3: Hardcode your API key here (NOT RECOMMENDED for production)
        // Uncomment and replace with your actual key:
        // return "YOUR_GEMINI_API_KEY_HERE"

        // No API key configured - app will fall back to MockAnalyzer
        return nil
    }()

    /// Check if Gemini API is available
    static var isGeminiConfigured: Bool {
        geminiApiKey != nil && !(geminiApiKey?.isEmpty ?? true)
    }
}
