import Foundation

typealias LogRepresentable = (String, String)

class LogBook {
    
    public static let sharedInstance = LogBook()
    
    private var logs: [LogRepresentable] = []
    private var subsystems: Set<String> = []
    private var logCount: Int = 15
    
    private init() {}
    
    func insert(_ message: Any, subsystem: LogSubsystem) {
        guard let stringMessage = message as? String else { return }
        
        let subsystemName = subsystem.subsystemName
        let subsystemLogs = logs.filter { $0.1 == subsystemName }
        if subsystemLogs.count >= logCount {
            if let index = logs.firstIndex(where: { $0.1 == subsystemName }) {
                logs.remove(at: index)
            }
        }
        
        logs.append((stringMessage, subsystemName))
        subsystems.insert(subsystem.subsystemName)
        print(subsystems)
        print(logs)
    }
    
    func setLogCount(_ count: Int) {
        logCount = count
    }
}
