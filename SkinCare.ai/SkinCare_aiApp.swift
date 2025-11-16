//
//  SkinCare_aiApp.swift
//  SkinCare.ai
//
//  Created by Aryan Signh on 10/09/25.
//

import SwiftUI

/// Main application entry point
/// Configures global app settings, services, and the root view
@main
struct SkinCare_aiApp: App {
    // MARK: - State Objects

    /// Camera service for capturing and processing images
    @StateObject private var cameraService = CameraService()

    // MARK: - Initialization

    init() {
        configureApp()
    }

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Theme.primaryTint)
                .environmentObject(cameraService)
                .task {
                    AppLogger.info("App launched", category: .general)
                    await cameraService.requestAccess()
                }
        }
    }

    // MARK: - Configuration

    /// Configures global app settings and initializes services
    private func configureApp() {
        // Log app startup
        AppLogger.info("SkinCare.ai initializing", category: .general)

        // Log API configuration status
        if Secrets.isGeminiConfigured {
            AppLogger.info("Gemini API configured", category: .general)
        } else {
            AppLogger.warning("Gemini API not configured - using MockAnalyzer", category: .general)
        }

        // Prepare haptic feedback generators for better responsiveness
        HapticManager.prepare()
    }
}
