//
//  File.swift
//  Qalam
//
//  Created by Usman_Nazir on 08/05/2026.
//

import Foundation

typealias LogRepresentable = (String, String)

class LogBook {
    
    public static let sharedInstance = LogBook()
    
    private var logs: [LogRepresentable] = []
    private var subsystems: Set<String> = []
    
    private init() {}
    
    func insert(_ message: Any, subsystem: LogSubsystem) {
        
        guard let stringMessage = message as? String else { return }
        subsystems.insert(subsystem.subsystemName)
        logs.append((stringMessage, subsystem.subsystemName))
        print("insert \(message) for subs \(subsystem)")
        print(subsystems)
        print(logs)
    }
}
