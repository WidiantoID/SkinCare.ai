//
//  SkinCare_aiApp.swift
//  SkinCare.ai
//
//  Created by Aryan Signh on 10/09/25.
//

import SwiftUI

@main
struct SkinCare_aiApp: App {
    @StateObject private var cameraService = CameraService()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(Theme.primaryTint)
                .environmentObject(cameraService)
                .task { await cameraService.requestAccess() }
        }
    }
}
