import SwiftUI

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
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "book.pages.fill")
                    .font(.system(size: 40, weight: .regular, design: .default))
                VStack(alignment: .leading, spacing: 5) {
                    Text("Log Book")
                        .font(.system(size: 25, weight: .bold, design: .monospaced))
                    Text("View the latest Qalam logs.")
                        .font(.system(size: 11, design: .monospaced))
                }
                Spacer()
                VStack {
                    Toggle(isOn: $isEnabled) {
                        
                    }
                    .frame(width: 40)
                    .padding(.trailing)
                    Picker("Subsystem", selection: $selectedSubsystem) {
                        Text("All").tag("All")
                        ForEach(Array(subsystems), id: \.self) { subsystem in
                            Text(subsystem).tag(subsystem)
                        }
                    }
                    .pickerStyle(.automatic)
                    .tint(.primary)
                }
            }
            .padding()
            Rectangle()
                .frame(height: 2)
                .foregroundStyle(.secondary)
                .ignoresSafeArea()

            List {
                Section {
                    ForEach(filteredLogs.reversed(), id: \.0) { log in
                        LazyVStack(alignment: .leading) {
                            Text(log.1)
                                .monospaced()
                                .textSelection(.enabled)
                            HStack(spacing: 5) {
                                Text(log.0 == .error ? "ERRR" : log.0 == .warning ? "WARN" : "INFO")
                                    .font(.system(size: 8))
                                    .monospaced()
                                    .bold()
                                    .foregroundStyle(.black)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 2)
                                    .background {
                                        Capsule()
                                            .fill(log.0 == .error ? .red : log.0 == .warning ? .yellow : .green)
                                            .opacity(0.65)
                                    }
                                Text(log.2)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                                    .monospaced()
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Latest logs appear at the top.")
                            .listRowBackground(EmptyView())
                        Spacer()
                        Button {
                            Task {
                                await logBook.clearAll()
                                logs.removeAll()
                                subsystems.removeAll()
                            }
                        } label: {
                            Text("Clear all")
                                .bold()
                        }
                    }
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundStyle(.secondary)
                }
                
                if filteredLogs.isEmpty {
                    Section {
                        ContentUnavailableView(
                            "Can't find your logs?",
                            systemImage: "questionmark.message.fill",
                            description: Text(
                                "Please ensure Log book is enabled using the toggle above."
                            )
                            .font(.caption)
                        )
                            .listRowBackground(EmptyView())
                    }
                }
            }
        }
        .onChange(of: isEnabled, { _, newValue in
            Log.logBookEnabled = newValue
        })
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
        .onAppear {
            Log.info("Data loaded from cache", .Core)
            Log.error("Cannot load puzzle", .named("Puzzles"))
            Log.warning("Recipe loading delay.", .named("Feast"))
        }
}
