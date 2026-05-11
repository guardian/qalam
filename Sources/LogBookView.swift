import SwiftUI

public struct LogBookView: View {

    let logBook: LogBook = .sharedInstance
    @State private var selectedSubsystem: String = "All"
    @State private var logs: [LogBookItem] = []
    @State private var subsystems: Set<String> = []
    @State private var isEnabled: Bool = Log.logBookEnabled

    var filteredLogs: [LogBookItem] {
        guard selectedSubsystem != "All" else { return logs }
        return logs.filter { $0.subsystem == selectedSubsystem }
    }

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            LogBookHeaderView(
                isEnabled: $isEnabled,
                selectedSubsystem: $selectedSubsystem,
                subsystems: subsystems
            )
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.secondary)
                .ignoresSafeArea()
            List {
                Section {
                    ForEach(filteredLogs.reversed(), id: \.message) { log in
                        LogRowView(log: log)
                    }
                } header: {
                    LogListHeaderView {
                        Task {
                            await logBook.clearAll()
                            logs.removeAll()
                            subsystems.removeAll()
                        }
                    }
                }
                if filteredLogs.isEmpty {
                    Section { LogListEmptyView() }
                }
            }
            .contentMargins(.top, 20)
        }
        .onChange(of: isEnabled) { _, newValue in
            Log.logBookEnabled = newValue
        }
        .onAppear {
            Task {
                logs = await logBook.logs
                subsystems = await logBook.subsystems
            }
        }
    }
}

// MARK: - Preview
#Preview {
    LogBookView()
        .onAppear {
            Log.info("Data loaded from cache", .Core)
            Log.error("Cannot load puzzle", .named("Puzzles"))
            Log.warning("Recipe loading delay.", .named("Feast"))
        }
}
