import SwiftUI

// MARK: - LogBookView
public struct LogBookView: View {

    let logBook: LogBook = .sharedInstance
    @State private var selectedSubsystem: String = "All"
    @State private var logs: [LogRepresentable] = []
    @State private var subsystems: Set<String> = []
    @State private var isEnabled: Bool = Log.logBookEnabled

    var filteredLogs: [LogRepresentable] {
        guard selectedSubsystem != "All" else { return logs }
        return logs.filter { $0.2 == selectedSubsystem }
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
                    ForEach(filteredLogs.reversed(), id: \.0) { log in
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

// MARK: - LogTypeTag
struct LogTypeTag: View {
    let type: LogType

    private var label: String {
        switch type {
        case .error: return "ERRR"
        case .warning: return "WARN"
        default: return "INFO"
        }
    }

    private var color: Color {
        switch type {
        case .error: return .red
        case .warning: return .yellow
        default: return .green
        }
    }

    var body: some View {
        Text(label)
            .font(.system(size: 8, weight: .bold, design: .monospaced))
            .foregroundStyle(.black)
            .padding(.horizontal, 4)
            .padding(.vertical, 2)
            .background(Capsule().fill(color).opacity(0.65))
    }
}

// MARK: - LogRowView
struct LogRowView: View {
    let log: LogRepresentable

    var body: some View {
        LazyVStack(alignment: .leading) {
            Text(log.1)
                .monospaced()
                .textSelection(.enabled)
            HStack(spacing: 5) {
                LogTypeTag(type: log.0)
                Text(log.2)
                    .foregroundStyle(.secondary)
                    .font(.caption)
                    .monospaced()
            }
        }
    }
}

// MARK: - LogListHeaderView
struct LogListHeaderView: View {
    let onClear: () -> Void

    var body: some View {
        HStack {
            Text("Latest logs appear at the top.")
            Spacer()
            Button(action: onClear) {
                Text("Clear all").bold()
            }
        }
        .font(.system(size: 12, weight: .regular, design: .monospaced))
        .foregroundStyle(.secondary)
    }
}

// MARK: - LogListEmptyView
struct LogListEmptyView: View {
    var body: some View {
        ContentUnavailableView(
            "Can't find your logs?",
            systemImage: "questionmark.message.fill",
            description: Text("Please ensure Log Book is enabled using the toggle above.")
                .font(.caption)
        )
        .listRowBackground(EmptyView())
    }
}

// MARK: - LogBookHeaderView
struct LogBookHeaderView: View {
    @Binding var isEnabled: Bool
    @Binding var selectedSubsystem: String
    let subsystems: Set<String>

    var body: some View {
        HStack {
            Image(systemName: "book.pages.fill")
                .font(.system(size: 40, weight: .regular))
            VStack(alignment: .leading, spacing: 5) {
                Text("Log Book")
                    .font(.system(size: 25, weight: .bold, design: .monospaced))
                Text("View the latest Qalam logs.")
                    .font(.system(size: 11, design: .monospaced))
            }
            Spacer()
            VStack(spacing: 0) {
                Toggle(isOn: $isEnabled) { }
                    .frame(width: 40)
                    .scaleEffect(0.8)
                    .padding(.trailing)
                Picker("Subsystem", selection: $selectedSubsystem) {
                    Text("All").tag("All")
                    ForEach(Array(subsystems).sorted(), id: \.self) { subsystem in
                        Text(subsystem).tag(subsystem)
                    }
                }
                .pickerStyle(.automatic)
                .tint(.primary)
            }
        }
        .padding()
        .dynamicTypeSize(.large)
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
