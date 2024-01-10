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
            return Logger(subsystem: "Revenue", category: category)
        }
    }
}
