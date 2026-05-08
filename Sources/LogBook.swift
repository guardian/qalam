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
        print("insert \(message) for subs \(subsystem)")
    }
}
