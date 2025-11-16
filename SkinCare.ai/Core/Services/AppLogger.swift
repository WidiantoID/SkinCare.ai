import Foundation
import os.log

/// Centralized logging system for the application
/// Provides structured logging with different severity levels
enum AppLogger {
    // MARK: - Log Levels

    /// Log categories for different parts of the app
    enum Category: String {
        case general = "General"
        case networking = "Networking"
        case database = "Database"
        case ui = "UI"
        case auth = "Authentication"
        case scan = "SkinScan"
        case camera = "Camera"
        case analytics = "Analytics"
    }

    // MARK: - Loggers

    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.skincare.ai"

    /// General application logger
    private static let generalLogger = Logger(subsystem: subsystem, category: Category.general.rawValue)

    /// Networking logger
    private static let networkLogger = Logger(subsystem: subsystem, category: Category.networking.rawValue)

    /// Database logger
    private static let databaseLogger = Logger(subsystem: subsystem, category: Category.database.rawValue)

    /// UI logger
    private static let uiLogger = Logger(subsystem: subsystem, category: Category.ui.rawValue)

    /// Authentication logger
    private static let authLogger = Logger(subsystem: subsystem, category: Category.auth.rawValue)

    /// Scan logger
    private static let scanLogger = Logger(subsystem: subsystem, category: Category.scan.rawValue)

    /// Camera logger
    private static let cameraLogger = Logger(subsystem: subsystem, category: Category.camera.rawValue)

    /// Analytics logger
    private static let analyticsLogger = Logger(subsystem: subsystem, category: Category.analytics.rawValue)

    // MARK: - Public Methods

    /// Logs a debug message
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The file where the log originates (automatic)
    ///   - function: The function where the log originates (automatic)
    ///   - line: The line number where the log originates (automatic)
    static func debug(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        #if DEBUG
        let logger = getLogger(for: category)
        let fileName = (file as NSString).lastPathComponent
        logger.debug("[\(fileName):\(line)] \(function) - \(message)")
        #endif
    }

    /// Logs an info message
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The file where the log originates (automatic)
    ///   - function: The function where the log originates (automatic)
    ///   - line: The line number where the log originates (automatic)
    static func info(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logger = getLogger(for: category)
        let fileName = (file as NSString).lastPathComponent
        logger.info("[\(fileName):\(line)] \(function) - \(message)")
    }

    /// Logs a warning message
    /// - Parameters:
    ///   - message: The message to log
    ///   - category: The category of the log
    ///   - file: The file where the log originates (automatic)
    ///   - function: The function where the log originates (automatic)
    ///   - line: The line number where the log originates (automatic)
    static func warning(
        _ message: String,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logger = getLogger(for: category)
        let fileName = (file as NSString).lastPathComponent
        logger.warning("[\(fileName):\(line)] \(function) - \(message)")
    }

    /// Logs an error message
    /// - Parameters:
    ///   - message: The message to log
    ///   - error: Optional error object
    ///   - category: The category of the log
    ///   - file: The file where the log originates (automatic)
    ///   - function: The function where the log originates (automatic)
    ///   - line: The line number where the log originates (automatic)
    static func error(
        _ message: String,
        error: Error? = nil,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logger = getLogger(for: category)
        let fileName = (file as NSString).lastPathComponent

        if let error = error {
            logger.error("[\(fileName):\(line)] \(function) - \(message) | Error: \(error.localizedDescription)")
        } else {
            logger.error("[\(fileName):\(line)] \(function) - \(message)")
        }
    }

    /// Logs a critical/fatal error
    /// - Parameters:
    ///   - message: The message to log
    ///   - error: Optional error object
    ///   - category: The category of the log
    ///   - file: The file where the log originates (automatic)
    ///   - function: The function where the log originates (automatic)
    ///   - line: The line number where the log originates (automatic)
    static func critical(
        _ message: String,
        error: Error? = nil,
        category: Category = .general,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logger = getLogger(for: category)
        let fileName = (file as NSString).lastPathComponent

        if let error = error {
            logger.critical("[\(fileName):\(line)] \(function) - \(message) | Error: \(error.localizedDescription)")
        } else {
            logger.critical("[\(fileName):\(line)] \(function) - \(message)")
        }
    }

    /// Logs a network request
    /// - Parameters:
    ///   - url: The URL being requested
    ///   - method: HTTP method
    ///   - statusCode: Response status code
    static func logNetworkRequest(url: String, method: String, statusCode: Int? = nil) {
        if let statusCode = statusCode {
            networkLogger.info("[\(method)] \(url) - Status: \(statusCode)")
        } else {
            networkLogger.info("[\(method)] \(url)")
        }
    }

    /// Logs an analytics event
    /// - Parameters:
    ///   - event: Event name
    ///   - parameters: Event parameters
    static func logAnalyticsEvent(_ event: String, parameters: [String: Any]? = nil) {
        if let parameters = parameters {
            analyticsLogger.info("Event: \(event) | Parameters: \(String(describing: parameters))")
        } else {
            analyticsLogger.info("Event: \(event)")
        }
    }

    // MARK: - Private Helpers

    private static func getLogger(for category: Category) -> Logger {
        switch category {
        case .general:
            return generalLogger
        case .networking:
            return networkLogger
        case .database:
            return databaseLogger
        case .ui:
            return uiLogger
        case .auth:
            return authLogger
        case .scan:
            return scanLogger
        case .camera:
            return cameraLogger
        case .analytics:
            return analyticsLogger
        }
    }
}

// MARK: - Usage Examples
/*
 // Debug logging
 AppLogger.debug("User tapped scan button", category: .ui)

 // Info logging
 AppLogger.info("Scan completed successfully", category: .scan)

 // Warning
 AppLogger.warning("API key not configured, using mock analyzer", category: .networking)

 // Error
 AppLogger.error("Failed to save scan result", error: error, category: .database)

 // Critical
 AppLogger.critical("App failed to initialize", error: error)

 // Network request
 AppLogger.logNetworkRequest(url: "https://api.example.com/analyze", method: "POST", statusCode: 200)

 // Analytics
 AppLogger.logAnalyticsEvent("scan_completed", parameters: ["duration": 2.5, "success": true])
 */
