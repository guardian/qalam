import Foundation

typealias LogRepresentable = (LogType, String, String)

actor LogBook {
    
    public static let sharedInstance = LogBook()
    
    internal var logs: [LogRepresentable] = []
    internal var subsystems: Set<String> = []
    private var logCount: Int = 15
    
    private init() {}
    
    func insert(_ type: LogType, _ message: Any, subsystem: LogSubsystem) {
        guard let stringMessage = message as? String else { return }
        
        let subsystemName = subsystem.subsystemName
        let subsystemLogs = logs.filter { $0.1 == subsystemName }
        if subsystemLogs.count >= logCount {
            if let index = logs.firstIndex(where: { $0.1 == subsystemName }) {
                logs.remove(at: index)
            }
        }
        
        logs.append((type, stringMessage, subsystemName))
        subsystems.insert(subsystem.subsystemName)
    }
    
    func setLogCount(_ count: Int) {
        logCount = count
    }
}
