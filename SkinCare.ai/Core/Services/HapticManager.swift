import UIKit

/// Centralized haptic feedback management
/// Provides consistent haptic feedback across the app
enum HapticManager {
    // MARK: - Feedback Generators

    private static let impactLight = UIImpactFeedbackGenerator(style: .light)
    private static let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private static let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
    private static let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    private static let impactRigid = UIImpactFeedbackGenerator(style: .rigid)
    private static let selection = UISelectionFeedbackGenerator()
    private static let notification = UINotificationFeedbackGenerator()

    // MARK: - Impact Feedback

    /// Light impact feedback
    /// Use for: Button taps, toggle switches, minor interactions
    static func light() {
        impactLight.prepare()
        impactLight.impactOccurred()
        AppLogger.debug("Light haptic feedback triggered", category: .ui)
    }

    /// Medium impact feedback
    /// Use for: Standard button taps, confirmations
    static func medium() {
        impactMedium.prepare()
        impactMedium.impactOccurred()
        AppLogger.debug("Medium haptic feedback triggered", category: .ui)
    }

    /// Heavy impact feedback
    /// Use for: Important actions, destructive actions
    static func heavy() {
        impactHeavy.prepare()
        impactHeavy.impactOccurred()
        AppLogger.debug("Heavy haptic feedback triggered", category: .ui)
    }

    /// Soft impact feedback
    /// Use for: Subtle interactions, scroll indicators
    static func soft() {
        impactSoft.prepare()
        impactSoft.impactOccurred()
        AppLogger.debug("Soft haptic feedback triggered", category: .ui)
    }

    /// Rigid impact feedback
    /// Use for: Firm interactions, precise selections
    static func rigid() {
        impactRigid.prepare()
        impactRigid.impactOccurred()
        AppLogger.debug("Rigid haptic feedback triggered", category: .ui)
    }

    // MARK: - Selection Feedback

    /// Selection changed feedback
    /// Use for: Picker selections, segment control changes, slider movement
    static func selection() {
        selection.prepare()
        selection.selectionChanged()
        AppLogger.debug("Selection haptic feedback triggered", category: .ui)
    }

    // MARK: - Notification Feedback

    /// Success notification feedback
    /// Use for: Successful operations, completion of tasks
    static func success() {
        notification.prepare()
        notification.notificationOccurred(.success)
        AppLogger.info("Success haptic feedback triggered", category: .ui)
    }

    /// Warning notification feedback
    /// Use for: Warning states, validation errors
    static func warning() {
        notification.prepare()
        notification.notificationOccurred(.warning)
        AppLogger.warning("Warning haptic feedback triggered", category: .ui)
    }

    /// Error notification feedback
    /// Use for: Error states, failed operations
    static func error() {
        notification.prepare()
        notification.notificationOccurred(.error)
        AppLogger.error("Error haptic feedback triggered", category: .ui)
    }

    // MARK: - Complex Patterns

    /// Celebrates a significant achievement
    /// Use for: Completing goals, major milestones
    static func celebrate() {
        DispatchQueue.main.async {
            success()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            light()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            medium()
        }
        AppLogger.info("Celebration haptic pattern triggered", category: .ui)
    }

    /// Signals a deletion or destructive action
    /// Use for: Delete operations, clearing data
    static func delete() {
        DispatchQueue.main.async {
            warning()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            heavy()
        }
        AppLogger.warning("Delete haptic pattern triggered", category: .ui)
    }

    /// Signals refresh or reload
    /// Use for: Pull to refresh, data reload
    static func refresh() {
        DispatchQueue.main.async {
            soft()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            light()
        }
        AppLogger.debug("Refresh haptic pattern triggered", category: .ui)
    }

    /// Signals scan completion
    /// Use for: When skin scan analysis completes
    static func scanComplete() {
        DispatchQueue.main.async {
            rigid()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            success()
        }
        AppLogger.info("Scan complete haptic pattern triggered", category: .scan)
    }

    // MARK: - Preparation

    /// Prepares all haptic generators
    /// Call this when the app launches for better responsiveness
    static func prepare() {
        impactLight.prepare()
        impactMedium.prepare()
        impactHeavy.prepare()
        impactSoft.prepare()
        impactRigid.prepare()
        selection.prepare()
        notification.prepare()
        AppLogger.info("Haptic feedback generators prepared", category: .ui)
    }
}

// MARK: - SwiftUI View Extension

import SwiftUI

extension View {
    /// Adds haptic feedback on tap
    /// - Parameter style: The haptic style to use
    /// - Returns: Modified view with haptic feedback
    func hapticFeedback(_ style: HapticStyle = .light) -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded { _ in
                switch style {
                case .light: HapticManager.light()
                case .medium: HapticManager.medium()
                case .heavy: HapticManager.heavy()
                case .soft: HapticManager.soft()
                case .rigid: HapticManager.rigid()
                case .selection: HapticManager.selection()
                }
            }
        )
    }
}

/// Haptic feedback styles
enum HapticStyle {
    case light
    case medium
    case heavy
    case soft
    case rigid
    case selection
}

// MARK: - Usage Examples
/*
 // Simple feedback
 HapticManager.light()
 HapticManager.success()
 HapticManager.error()

 // Complex patterns
 HapticManager.celebrate()
 HapticManager.delete()
 HapticManager.scanComplete()

 // SwiftUI view modifier
 Button("Tap Me") {
     // action
 }
 .hapticFeedback(.medium)

 // Prepare on app launch
 HapticManager.prepare()
 */
