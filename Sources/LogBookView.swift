import SwiftUI

public struct LogBookView: View {
    
    let logBook: LogBook = .sharedInstance
    @State private var selectedSubsystem: String = "All"
    @State private var logs: [LogRepresentable] = []
    @State private var subsystems: Set<String> = []
    
    var filteredLogs: [LogRepresentable] {
        guard selectedSubsystem != "All" else { return logs }
        return logs.filter { $0.1 == selectedSubsystem }
    }
    
    public var body: some View {
        VStack {
            HStack {
                Image(systemName: "book.pages")
                    .font(.system(size: 40, weight: .bold, design: .default))
                VStack(alignment: .leading) {
                    Text("Log Book")
                        .font(.system(size: 30, weight: .heavy, design: .default))
                    Text("View the latest Qalam logs.")
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                }
                Spacer()
                Picker("Subsystem", selection: $selectedSubsystem) {
                    Text("All").tag("All")
                    ForEach(Array(subsystems), id: \.self) { subsystem in
                        Text(subsystem).tag(subsystem)
                    }
                }
                .pickerStyle(.automatic)
            }
            .padding()
            List(filteredLogs.reversed(), id: \.0) { log in
                VStack(alignment: .leading) {
                    Text(log.0)
                    Text(log.1)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .task {
            logs = await logBook.logs
            subsystems = await logBook.subsystems
            Log.info("Usman", .named("test"))
            Log.info("Usman", .named("test"))
            Log.info("Usman", .named("test"))
            Log.info("MNS", .named("foo"))
            Log.info("Usman", .named("test"))
            Log.info("MNS", .named("foo"))
            Log.info("MNS", .named("foo"))
        }
    }
}

#Preview {
    LogBookView()
}
