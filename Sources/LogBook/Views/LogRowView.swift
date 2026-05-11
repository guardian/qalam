import SwiftUI

struct LogRowView: View {
    let log: LogBookItem

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 12) {
            Text(log.message)
                .font(.system(size: 12, weight: .regular, design: .monospaced))
                .textSelection(.enabled)
            HStack(spacing: 5) {
                LogTypeTagView(type: log.type)
                Text(log.subsystem.uppercased())
                    .foregroundStyle(.secondary)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
            }
        }
    }
}
