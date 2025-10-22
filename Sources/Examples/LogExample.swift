//
//  LogExample.swift
//
//  Created by Usman Nazir on 03/10/2023.
//

import Foundation

/// This file contains examples of using different Logging functions.

/// Logs an integer value using the `Log` class.
func logInt() {
    let value = 1
    
    Log.console(value)
    Log.console(value, .info)
    Log.console(value, .warning)
    Log.console(value, .error)
    Log.console(value, .info, .Core)
    Log.console(value, .info, .experiments)
}

/// Logs a floating-point value using the `Log` class.
func logFloat() {
    let value = 1.5
    
    Log.console(value)
    Log.console(value, .info)
    Log.console(value, .warning)
    Log.console(value, .error)
    Log.console(value, .info, .Core)
    Log.console(value, .info, .metering)
}

/// Logs the current date using the `Log` class.
func logDate() {
    let value = Date.now
    
    Log.console(value)
    Log.console(value, .info)
    Log.console(value, .warning)
    Log.console(value, .error)
    Log.console(value, .info, .Core)
    Log.console(value, .info, .appsExperience)
}

/// Logs an array of strings using the `Log` class.
func logArray() {
    let value = ["A", "B", "C"]
    
    Log.console(value)
    Log.console(value, .info)
    Log.console(value, .warning)
    Log.console(value, .error)
    Log.console(value, .info, .Core)
    Log.console(value, .info, .metering)
}

/// Logs a custom object using the `Log` class.
func logObject() {
    
    struct LoggableObject: CustomStringConvertible, Codable {
        let x: Int
        let y: Int
        
        /// Provides a custom string representation of the object.
        var description: String {
            "x: \(x)\ny: \(y)" + "\n"
        }
    }
    
    let value = LoggableObject(x: 4, y: 8)
    
    Log.console(value)
    Log.console(value, .info)
    Log.console(value, .warning)
    Log.console(value, .error)
    Log.console(value, .info, .Core)
    Log.console(value, .info, .metering)
}

/// Logs an array of custom objects using the `Log` class.
func logObjectArray() {
    
    struct LoggableObject: CustomStringConvertible, Codable {
        let x: Int
        let y: Int
        
        /// Provides a custom string representation of the object.
        var description: String {
            "\n" + "x: \(x)\ny: \(y)" + "\n"
        }
    }
    
    let value = [LoggableObject(x: 4, y: 8), LoggableObject(x: 3, y: 6)]
    
    Log.console(value)
    Log.console(value, .info)
    Log.console(value, .warning)
    Log.console(value, .error)
    Log.console(value, .info, .Core)
    Log.console(value, .info, .metering)
}

func logUnsupportedObject() {
    
    struct UnsupportedObject: Codable {
        let x: Int
        let y: Int
        
        /// Provides a custom string representation of the object.
        var description: String {
            "\n" + "x: \(x)\ny: \(y)" + "\n"
        }
    }
    
    Log.console(UnsupportedObject(x: 1, y: 2))
}

/// Logs an Error using the `Log` class.
func logError() {
    
    enum SomeErrorWithDescription: CustomStringConvertible, Error {
        case AnError
        
        var description: String {
            switch self {
            case .AnError:
                "An Error occured!"
            }
        }
    }
    
    enum SomeErrorWithoutDescription: Error {
        case AnError
        case AnotherError
    }
    
    let valueWithDesc = SomeErrorWithDescription.AnError
    let valueWithoutDesc = SomeErrorWithoutDescription.AnError
    let anotherValueWithoutDesc = SomeErrorWithoutDescription.AnotherError
    
    Log.console(valueWithoutDesc)
    Log.console(valueWithoutDesc, .info)
    Log.console(valueWithoutDesc, .warning)
    Log.console(valueWithoutDesc, .error)
    Log.console(valueWithoutDesc, .info, .Core)
    Log.console(valueWithoutDesc, .info, .metering)
    Log.console(valueWithoutDesc, .error)
    
    Log.console(anotherValueWithoutDesc)
    Log.console(anotherValueWithoutDesc, .info)
    Log.console(anotherValueWithoutDesc, .info, .metering)
    Log.console(anotherValueWithoutDesc, .error)
    
    Log.console(valueWithDesc)
    Log.console(valueWithDesc, .info)
    Log.console(valueWithDesc, .warning)
    Log.console(valueWithDesc, .error)
    Log.console(valueWithDesc, .info, .Core)
    Log.console(valueWithDesc, .info, .metering)
    Log.console(valueWithDesc, .error)
    
    Log.console("There's been an error!", .error, .appsExperience)
}

func traceLog() {
    Log.trace(.experiments).info("This log can be traced back in code!")
    Log.console("XYZ", .warning, .experiments, "Search in Masthead")
}

func logLevels() {
    Log.console("One")
    Log.console("Two", .warning)
    Log.console("Three", .warning, .personalisation)
    Log.console("Four", .error, .personalisation, "My Guardian")
    print("ABC")
}

func infoLogs() {
    Log.info("One")
    Log.info("Two", .Core)
    Log.info("Three", .named(system: "Custom Module"))
}

func warningLogs() {
    Log.warning("One")
    Log.warning("Two", .Core)
    Log.warning("Three", .named(system: "Custom Module"))
}

func errorLogs() {
    Log.error("One")
    Log.error("Two", .Core)
    Log.error("Three", .named(system: "Custom Module"))
}

func customLogs() {
    Log.info("One", .named(system: "Custom Module 1"))
    Log.warning("Two", .named(system: "Custom Module 2"))
    Log.error("Three", .named(system: "Custom Module 3"))
}

func logUsingNames() {
    Log.info("One", .named(system: "Something"))
    Log.warning("Two", .named("Also Something"))
}

func logUsingEnum() {
    // An enum that can be logged to Qalam
    enum SomeLoggableEnum: String, QalamLoggable {
        case one
        case two
    }
    
    Log.info("One", .module(SomeLoggableEnum.one))
    Log.info("Two", .module(SomeLoggableEnum.two))
}
