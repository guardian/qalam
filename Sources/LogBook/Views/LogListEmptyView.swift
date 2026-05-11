import SwiftUI

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
