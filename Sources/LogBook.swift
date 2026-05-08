//
//  File.swift
//  Qalam
//
//  Created by Usman_Nazir on 08/05/2026.
//

import Foundation

class LogBook {
    
    public static let sharedInstance = LogBook()
    
    private var logs: [String:String] = [:]
    private var subsystems: Set<String> = []
    
    private init() {}
    
    func insert(_ message: Any, subsystem: LogSubsystem) {
        
        guard let stringMessage = message as? String else { return }
        subsystems.insert(subsystem.subsystemName)
        logs[subsystem.subsystemName] = stringMessage
        print("insert \(message) for subs \(subsystem)")
        print(subsystems)
        print(logs)
    }
}
