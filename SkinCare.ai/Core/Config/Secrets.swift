import Foundation

enum Secrets {
    static let geminiApiKey: String? = {
        if let env = ProcessInfo.processInfo.environment["GEMINI_API_KEY"], !env.isEmpty {
            return env
        }
        return "AIzaSyBRQ5OX_XZzPgBrLIn_zAXnxPO63KWHqBc"
    }()
}


