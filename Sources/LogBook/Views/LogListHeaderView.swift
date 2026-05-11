import SwiftUI

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
