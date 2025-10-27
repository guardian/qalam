//
//  LogSubsystem.swift
//  NewLogger
//
//  Created by Usman Nazir on 03/10/2023.
//

import Foundation
import OSLog

/// Represents different modules for logging within the application.
///
/// Each module corresponds to a specific category within the logging system.
public enum LogSubsystem {
    
    /// Guardian Live App module.
    case Core
    
    /// Fronts or main sections of the application.
    case appsExperience
    
    /// User personalisation features.
    case personalisation
    
    /// Experimental features or A/B testing.
    case experiments
    
    /// Metering specific related logs.
    case metering

    /// Growth and Value features. e.g Storekit and Acquisition related features.
    case revenue

    /// Nophan logs for the First Party Tracking package.
    case nophan

    /// Deeplinking related logs, related to the deeplink manager.
    case deeplinking
    
    /// Puzzles features.
    case puzzles
    
    /// Case to adapt any other sub system
    case named(system: String)
    
    /// Case to adapt any other Loggable enum to Qalam
    case module(systemLoggable: any QalamLoggable)

    public func loggerFunc(category: String) -> Logger {
        switch self {
        case .Core:
            return Logger(subsystem: "Core", category: category)
        case .appsExperience:
            return Logger(subsystem: "Apps Experience", category: category)
        case .personalisation:
            return Logger(subsystem: "Personalisation", category: category)
        case .experiments:
            return Logger(subsystem: "Experiments", category: category)
        case .metering:
            return Logger(subsystem: "Metering", category: category)
        case .revenue:
            return Logger(subsystem: "Supporter Revenue", category: category)
        case .nophan:
            return Logger(subsystem: "Nophan", category: category)
        case .deeplinking:
            return Logger(subsystem: "Deeplinking", category: category)
        case .puzzles:
            return Logger(subsystem: "Puzzles", category: category)
        case .named(let system):
            return Logger(subsystem: "\(system.capitalized)", category: category)
        case .module(let systemLoggable):
            return Logger(subsystem: "\(systemLoggable.rawValue.capitalized)", category: category)
        }
    }
}

// Helper/Convenience functions
extension LogSubsystem {
    
    /// Creates a dynamic logging subsystem by name.
    ///
    /// Example:
    /// ```swift
    /// let custom = Log.info("Hello!", .named("Usman"))
    /// ```
    public static func named(_ name: String) -> LogSubsystem {
        .named(system: name)
    }
    
    /// Creates a dynamic logging subsystem by loggable enum.
    public static func module(_ module: any QalamLoggable) -> LogSubsystem {
        .module(systemLoggable: module)
    }
}
