import SwiftUI

struct ErrorRetryView: View {
	let message: String
	let onRetry: () -> Void

	var body: some View {
		VStack(spacing: 16) {
			Image(systemName: "exclamationmark.triangle")
				.font(.system(size: 48))
				.foregroundStyle(.secondary)

			Text(message)
				.font(.headline)
				.foregroundStyle(.secondary)
				.multilineTextAlignment(.center)

			Button("Retry", action: onRetry)
				.buttonStyle(.borderedProminent)
		}
		.padding()
	}
}
