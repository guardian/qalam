import SwiftUI

public struct LogBookView: View {
    
    let logBook: LogBook = .sharedInstance
    @State private var selectedSubsystem: String = "All"
    @State private var logs: [LogRepresentable] = []
    @State private var subsystems: Set<String> = []
    
    var filteredLogs: [LogRepresentable] {
        guard selectedSubsystem != "All" else { return logs }
        return logs.filter { $0.2 == selectedSubsystem }
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
                        .foregroundStyle(.secondary)
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
                        Text(log.1)
                        HStack(spacing: 5) {
                            Group {
                                Circle()
                                    .fill(log.0 == .error ? .red : log.0 == .warning ? .yellow : .green)
                                    .frame(width: 5, height: 5)
                            }
                            .font(.system(size: 5))
                            Text(log.2)
                                .foregroundStyle(.secondary)
                            .font(.caption)
                        }
                    }
            }
        }
        .onAppear {
            Task {
                logs = await logBook.logs
                subsystems = await logBook.subsystems
            }
        }
    }
}

#Preview {
    LogBookView()
    Button("Test") {
        Log.info("ABC", .named("london"))
        Log.error("123", .named("paris"))
        Log.warning("XYZ", .named("newyork"))
    }
}
