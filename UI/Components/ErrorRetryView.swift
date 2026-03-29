import SwiftUI

struct ErrorRetryView: View {
	let message: String
	let onRetry: () -> Void

	@State private var iconBounce = false

	var body: some View {
		VStack(spacing: 20) {
			ZStack {
				Circle()
					.fill(Color.red.opacity(0.1))
					.frame(width: 88, height: 88)

				Image(systemName: "exclamationmark.triangle.fill")
					.font(.system(size: 36))
					.foregroundStyle(Color.red.opacity(0.85))
					.offset(y: iconBounce ? -4 : 0)
			}

			VStack(spacing: 6) {
				Text("Oops!")
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundStyle(.white)

				Text(message)
					.font(.system(size: 15, weight: .medium))
					.foregroundStyle(AppTheme.subtitleGray)
					.multilineTextAlignment(.center)
			}

			Button(action: onRetry) {
				HStack(spacing: 8) {
					Image(systemName: "arrow.clockwise")
						.font(.system(size: 14, weight: .semibold))
					Text("Try Again")
						.font(.system(size: 15, weight: .semibold, design: .rounded))
				}
				.foregroundStyle(.white)
				.padding(.horizontal, 28)
				.padding(.vertical, 12)
				.background(
					Capsule()
						.fill(AppTheme.githubGradient)
				)
			}
			.padding(.top, 4)
		}
		.padding(32)
		.onAppear {
			withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
				iconBounce = true
			}
		}
	}
}
