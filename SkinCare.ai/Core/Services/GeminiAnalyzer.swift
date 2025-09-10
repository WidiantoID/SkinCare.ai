import Foundation

public final class GeminiAnalyzer: MLAnalyzing {
    private let apiKey: String
    private let session: URLSession

    public init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    public func analyzeSkin(from imageData: Data) async throws -> ScanResult {
        guard !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "GeminiAnalyzer", code: -2, userInfo: [NSLocalizedDescriptionKey: "Missing Gemini API key"])
        }
        
        // Get user data on main actor
        let (userName, userAge) = await MainActor.run {
            let userData = UserData.shared
            return (userData.name, userData.age)
        }
        
        // This is a placeholder hitting Gemini Vision-style endpoint.
        // Replace endpoint/payload per your provider's latest spec.
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!

        let base64 = imageData.base64EncodedString()
        let availableIngredients = """
        Available ingredients: Salicylic Acid, Azelaic Acid, Niacinamide, Vitamin C, Retinol, Retinal, Hyaluronic Acid, Ceramides, Glycolic Acid, Lactic Acid, Mandelic Acid, Benzoyl Peroxide, Zinc, Arbutin, Kojic Acid, Tranexamic Acid, Bakuchiol, Peptides, Squalane, Centella Asiatica, Green Tea, Licorice Root
        """
        
        // Create personalized user context
        let userContext = userName.isEmpty && userAge.isEmpty ? "" : """
        
        User Information:
        - Name: \(userName.isEmpty ? "Not provided" : userName)
        - Age: \(userAge.isEmpty ? "Not provided" : userAge)
        
        Please provide personalized recommendations considering the user's age and any age-related skin concerns.
        """
        
        let prompt = """
        Analyze this facial skin image for visible concerns. Provide:
        1. A brief paragraph describing the skin condition and overall assessment
        2. Top 3-5 recommended ingredients from the available list that would help
        
        \(availableIngredients)\(userContext)
        
        Focus on: acne, redness, dark spots, wrinkles, pigmentation, dryness, oiliness, sensitivity, dullness, dehydration, sun damage, pores, texture.
        
        Return JSON format:
        {
          "skinAnalysis": "Brief paragraph describing skin condition",
          "recommendedIngredients": ["ingredient1", "ingredient2", "ingredient3"],
          "conditions": [{"condition": "acne", "confidence": 0.8}]
        }
        """

        let body: [String: Any] = [
            "contents": [[
                "parts": [
                    ["text": prompt],
                    [
                        "inline_data": [
                            "mime_type": "image/jpeg",
                            "data": base64
                        ]
                    ]
                ]
            ]]
        ]

        let requestData = try JSONSerialization.data(withJSONObject: body, options: [])
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = requestData

        let (data, response) = try await session.data(for: req)
        guard let http = response as? HTTPURLResponse else {
            throw NSError(domain: "GeminiAnalyzer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        guard (200..<300).contains(http.statusCode) else {
            let apiMessage = (try? JSONSerialization.jsonObject(with: data) as? [String: Any])?["error"] as? [String: Any]
            let message = apiMessage?["message"] as? String
            throw NSError(domain: "GeminiAnalyzer", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: message ?? "Gemini API error: \(http.statusCode)"])
        }

        // Parse model output; expect JSON in text. Fallback to mock if parsing fails.
        let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        // Very rough extraction of text candidates per Gemini response shape
        let text = (((decoded?["candidates"] as? [[String: Any]])?.first)?["content"] as? [String: Any])?["parts"] as? [[String: Any]]
        let combined = text?.compactMap { $0["text"] as? String }.joined(separator: "\n") ?? ""

        let analysisResult = Self.parseAnalysisResult(from: combined)
        let scores = analysisResult.scores.isEmpty ? SkinCondition.allCases.map { ConditionScore(condition: $0, confidence: 0.0) } : analysisResult.scores
        
        return ScanResult(
            imageIdentifier: UUID().uuidString, 
            scores: scores,
            skinAnalysis: analysisResult.skinAnalysis,
            recommendedIngredients: analysisResult.recommendedIngredients
        )
    }

    private static func parseAnalysisResult(from text: String) -> (scores: [ConditionScore], skinAnalysis: String?, recommendedIngredients: [String]) {
        // Try to find JSON object in the text
        guard let start = text.firstIndex(of: "{"), let end = text.lastIndex(of: "}") else {
            return (scores: [], skinAnalysis: nil, recommendedIngredients: [])
        }
        
        let jsonSlice = text[start...end]
        guard let data = String(jsonSlice).data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return (scores: [], skinAnalysis: nil, recommendedIngredients: [])
        }
        
        let skinAnalysis = json["skinAnalysis"] as? String
        let recommendedIngredients = json["recommendedIngredients"] as? [String] ?? []
        
        var scores: [ConditionScore] = []
        if let conditions = json["conditions"] as? [[String: Any]] {
            for item in conditions {
                guard let name = item["condition"] as? String else { continue }
                let conf = (item["confidence"] as? Double) ?? 0.0
                if let condition = SkinCondition(rawValue: name.camelKey()) {
                    scores.append(ConditionScore(condition: condition, confidence: max(0, min(conf, 1))))
                }
            }
        }
        
        return (scores: scores, skinAnalysis: skinAnalysis, recommendedIngredients: recommendedIngredients)
    }
    
    private static func parseScores(from text: String) -> [ConditionScore] {
        // Legacy method for backward compatibility
        let result = parseAnalysisResult(from: text)
        return result.scores
    }
}

private extension String {
    func camelKey() -> String {
        lowercased().replacingOccurrences(of: " ", with: "")
    }
}


