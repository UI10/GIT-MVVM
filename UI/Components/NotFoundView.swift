import SwiftUI

struct NotFoundView: View {
	let username: String

	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "person.slash")
				.font(.system(size: 48))
				.foregroundStyle(.secondary)

			Text("User not found")
				.font(.headline)

			Text("No GitHub user matches \"\(username)\"")
				.font(.subheadline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)
		}
		.padding()
	}
}
