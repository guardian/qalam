//
//  Log.swift
//  NewLogger
//
//  Created by Usman Nazir on 03/10/2023.
//

import Foundation
import OSLog

/// Provides centralized logging functionalities.
public class Log {
    
#if DEBUG
    /// This Static flag controls when to log to console. Trace logs are not effected by this flag and bypass it.
    private static var isEnabled = true
#else
    private static var isEnabled = false
#endif
    
    /// Logs the given object to the console with specified type and module.
    ///
    /// Examples:
    ///
    /// ```
    ///   Log.console(value, .info, .Core)
    ///   Log.console(value, .info, .metering)
    ///
    /// ```
    ///
    /// - Parameters:
    ///   - obj: The object to be logged.
    ///   - type: The severity or type of the log. Default is `.info`.
    ///   - module: The module to which the log belongs. Default is `.GLA`.
    public static func console(_ obj: Any, _ type: LogType = .info, _ module: LogSubsystem = .Core, _ category: String? = nil) {
        guard isEnabled else { return }
        logToModule(obj, logger: module.loggerFunc(category: category ?? "Default"), type: type)
    }
    
    /// Logs the given object to the console with specified type and default module `.GLA`.
    ///
    ///```
    ///   Log.console(value)
    ///   Log.console(value, .info)
    ///   Log.console(value, .warning)
    ///   Log.console(value, .error)
    ///```
    ///
    /// - Parameters:
    ///   - obj: The object to be logged.
    ///   - type: The severity or type of the log. Default is `.info`.
    public static func console(_ obj: Any, _ type: LogType = .info) {
        guard isEnabled else { return }
        logToModule(obj, logger: LogSubsystem.Core.loggerFunc(category: "Default"), type: type)
    }
    
    /// Returns the Logger for the module that can be used to accurately trace the Logs in the console.
    /// Trace is not dependant on isEnabled. It will always be enabled so avoid releasing to production with Trace statements.
    ///
    ///```
    ///   Log.trace(.experiments).info("This log can be traced back in code!")
    ///```
    ///
    /// - Parameters:
    ///   - module: The module to which the log belongs. Default is `.GLA`.
    public static func trace(_ module: LogSubsystem) -> Logger {
        return module.loggerFunc(category: "Default")
    }
    
    /// Logs the object to the specified module.
    ///
    /// - Parameters:
    ///   - obj: The object to be logged.
    ///   - logger: The logger instance for the module.
    ///   - type: The severity or type of the log.
    private static func logToModule(_ obj: Any, logger: Logger, type: LogType) {
        if let object = obj as? CustomStringConvertible {
            if obj is Error {
                logToType("\(object.description)", logger: logger, type: .error)
                return
            }
            logToType(object.description, logger: logger, type: type)
        } else if obj is Int ||
                    obj is String ||
                    obj is Float ||
                    obj is Double ||
                    obj is [Any] {
            logToType("\(obj)", logger: logger, type: type)
        } else if let errorObj = obj as? Error {
            logToType("\(errorObj) : \(errorObj.localizedDescription)", logger: logger, type: .error)
        } else {
            logToType("Unsupported Logging Type. Please make sure the Object type conforms to CustomStringConvertible.", logger: logger, type: .error)
        }
    }
    
    /// Logs the description of the object based on the log type.
    ///
    /// - Parameters:
    ///   - description: The string representation of the object.
    ///   - logger: The logger instance for the module.
    ///   - type: The severity or type of the log.
    private static func logToType(_ description: String, logger: Logger, type: LogType) {
        switch type {
        case .info:
            logger.info("\(description)")
        case .warning:
            logger.warning("\(description)")
        case .error:
            logger.fault("\(description)")
        }
    }
}
