import Foundation

/// A tuple representing a single log entry containing the log type, message, and subsystem name.
typealias LogRepresentable = (LogType, String, String)

/// A thread-safe actor responsible for storing and managing in-memory log entries.
///
/// `LogBook` maintains a rolling window of logs per subsystem in FIFO order,
/// and tracks all unique subsystems that have been logged to.
///
/// - Note: Access the shared instance via ``sharedInstance``.
actor LogBook {

    /// The shared singleton instance of `LogBook`.
    public static let sharedInstance = LogBook()

    /// The stored log entries across all subsystems.
    internal var logs: [LogRepresentable] = []

    /// The set of unique subsystem names that have been logged to.
    internal var subsystems: Set<String> = []

    /// The maximum number of log entries retained per subsystem. Defaults to `15`. Can be updated using ``setLogCount()``
    private var logCount: Int = 15

    private init() {}

    /// Inserts a new log entry for the given subsystem.
    ///
    /// If the subsystem has reached ``logCount``, the oldest entry for that subsystem
    /// is removed before inserting the new one (FIFO).
    ///
    /// - Parameters:
    ///   - type: The ``LogType`` of the log entry.
    ///   - message: The message to log. Must be a `String`, otherwise the call is ignored.
    ///   - subsystem: The ``LogSubsystem`` associated with this log entry.
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
        subsystems.insert(subsystemName)
    }

    /// Sets the maximum number of log entries retained per subsystem.
    ///
    /// When the limit is reached, the oldest entry for that subsystem is removed (FIFO).
    ///
    /// - Parameter count: The maximum number of logs to retain per subsystem.
    func setLogCount(_ count: Int) {
        logCount = count
    }

    /// Clears all log entries and subsystem records.
    func clearAll() {
        logs.removeAll()
        subsystems.removeAll()
    }
}
