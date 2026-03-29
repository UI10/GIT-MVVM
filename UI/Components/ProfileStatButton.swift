import SwiftUI

struct ProfileStatButton: View {
	let count: Int
	let label: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			VStack(spacing: 4) {
				Text("\(count)")
					.font(.title2.bold())

				Text(label)
					.font(.caption)
					.foregroundStyle(.secondary)
			}
		}
		.buttonStyle(.plain)
	}
}
