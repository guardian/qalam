import SwiftUI

struct LogTypeTagView: View {
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
