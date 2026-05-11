import SwiftUI

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
                    .frame(width: 10)
                    .scaleEffect(0.9)
                    .padding(.trailing)
                    .tint(.indigo)
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
