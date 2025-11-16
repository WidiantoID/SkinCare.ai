import Foundation
import Network
import Combine

/// Monitors network connectivity status
/// Publishes changes to network availability
@MainActor
class NetworkMonitor: ObservableObject {
    // MARK: - Singleton

    static let shared = NetworkMonitor()

    // MARK: - Published Properties

    /// Whether network is currently available
    @Published private(set) var isConnected: Bool = true

    /// Whether network is expensive (cellular data)
    @Published private(set) var isExpensive: Bool = false

    /// Whether network is constrained (low data mode)
    @Published private(set) var isConstrained: Bool = false

    /// Current connection type
    @Published private(set) var connectionType: ConnectionType = .unknown

    // MARK: - Private Properties

    private let monitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "com.skincare.ai.network.monitor")

    // MARK: - Connection Types

    enum ConnectionType: String {
        case wifi = "WiFi"
        case cellular = "Cellular"
        case wiredEthernet = "Ethernet"
        case unknown = "Unknown"
    }

    // MARK: - Initialization

    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Monitoring

    /// Starts monitoring network status
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                guard let self = self else { return }

                let wasConnected = self.isConnected
                self.isConnected = path.status == .satisfied
                self.isExpensive = path.isExpensive
                self.isConstrained = path.isConstrained
                self.connectionType = self.determineConnectionType(from: path)

                // Log status changes
                if wasConnected != self.isConnected {
                    if self.isConnected {
                        AppLogger.info("Network connected: \(self.connectionType.rawValue)", category: .networking)
                    } else {
                        AppLogger.warning("Network disconnected", category: .networking)
                    }
                }

                // Log expensive/constrained status
                if self.isExpensive {
                    AppLogger.info("Network is expensive (cellular)", category: .networking)
                }
                if self.isConstrained {
                    AppLogger.info("Network is constrained (low data mode)", category: .networking)
                }
            }
        }

        monitor.start(queue: monitorQueue)
        AppLogger.info("Network monitoring started", category: .networking)
    }

    /// Stops monitoring network status
    func stopMonitoring() {
        monitor.cancel()
        AppLogger.info("Network monitoring stopped", category: .networking)
    }

    // MARK: - Helper Methods

    private func determineConnectionType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else {
            return .unknown
        }
    }

    /// Checks if network is available and not constrained
    var isConnectionGood: Bool {
        isConnected && !isConstrained
    }

    /// Checks if it's safe to download large files
    var canDownloadLargeFiles: Bool {
        isConnected && !isExpensive && !isConstrained
    }

    /// Gets a user-friendly network status message
    var statusMessage: String {
        if !isConnected {
            return "No internet connection"
        } else if isConstrained {
            return "Limited connectivity (Low Data Mode)"
        } else if isExpensive {
            return "Connected via \(connectionType.rawValue) (Cellular Data)"
        } else {
            return "Connected via \(connectionType.rawValue)"
        }
    }
}

// MARK: - SwiftUI View Extension

import SwiftUI

extension View {
    /// Shows an alert when network becomes unavailable
    /// - Parameter isPresented: Binding to control alert visibility
    /// - Returns: Modified view with network alert
    func networkAlert(isPresented: Binding<Bool>) -> some View {
        self.alert("No Internet Connection", isPresented: isPresented) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please check your internet connection and try again.")
        }
    }

    /// Shows a banner when network is unavailable
    /// - Returns: Modified view with network status banner
    func networkStatusBanner() -> some View {
        self.modifier(NetworkStatusBannerModifier())
    }
}

// MARK: - Network Status Banner Modifier

struct NetworkStatusBannerModifier: ViewModifier {
    @StateObject private var networkMonitor = NetworkMonitor.shared
    @State private var showBanner = false

    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content

            if !networkMonitor.isConnected && showBanner {
                NetworkStatusBanner(
                    message: "No Internet Connection",
                    icon: "wifi.slash",
                    color: .red
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(999)
            } else if networkMonitor.isConstrained && showBanner {
                NetworkStatusBanner(
                    message: "Low Data Mode Active",
                    icon: "antenna.radiowaves.left.and.right.slash",
                    color: .orange
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(999)
            }
        }
        .onChange(of: networkMonitor.isConnected) { newValue in
            withAnimation(.spring()) {
                showBanner = !newValue
            }
        }
        .onChange(of: networkMonitor.isConstrained) { newValue in
            withAnimation(.spring()) {
                showBanner = newValue && networkMonitor.isConnected
            }
        }
    }
}

// MARK: - Network Status Banner

struct NetworkStatusBanner: View {
    let message: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Text(message)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white)

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(color.gradient)
        )
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Usage Examples
/*
 // In your app
 @StateObject private var networkMonitor = NetworkMonitor.shared

 var body: some View {
     ContentView()
         .networkStatusBanner()
 }

 // Check connectivity before network calls
 if NetworkMonitor.shared.isConnected {
     // Make API call
 } else {
     // Show error
 }

 // Check if safe to download large files
 if NetworkMonitor.shared.canDownloadLargeFiles {
     // Download large file
 } else {
     // Show warning
 }

 // Get status message
 Text(NetworkMonitor.shared.statusMessage)
 */
