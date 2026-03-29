import SwiftUI

struct NotFoundView: View {
	let username: String

	@State private var fadeIn = false

	var body: some View {
		VStack(spacing: 20) {
			ZStack {
				Circle()
					.fill(Color.orange.opacity(0.1))
					.frame(width: 88, height: 88)

				Image(systemName: "person.slash.fill")
					.font(.system(size: 36))
					.foregroundStyle(Color.orange.opacity(0.85))
			}

			VStack(spacing: 6) {
				Text("User Not Found")
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundStyle(.white)

				Text("No GitHub user matches")
					.font(.system(size: 15, weight: .medium))
					.foregroundStyle(AppTheme.subtitleGray)

				Text("\"\(username)\"")
					.font(.system(size: 15, weight: .semibold, design: .monospaced))
					.foregroundStyle(AppTheme.accentGreen)
			}
		}
		.padding(32)
		.opacity(fadeIn ? 1 : 0)
		.offset(y: fadeIn ? 0 : 12)
		.onAppear {
			withAnimation(.easeOut(duration: 0.4)) {
				fadeIn = true
			}
		}
	}
}
