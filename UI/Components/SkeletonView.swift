import SwiftUI

struct SkeletonView: View {
	@State private var isAnimating = false

	var body: some View {
		VStack(spacing: 16) {
			Circle()
				.fill(Color.gray.opacity(0.3))
				.frame(width: 100, height: 100)

			RoundedRectangle(cornerRadius: 4)
				.fill(Color.gray.opacity(0.3))
				.frame(width: 150, height: 20)

			RoundedRectangle(cornerRadius: 4)
				.fill(Color.gray.opacity(0.3))
				.frame(width: 100, height: 16)

			RoundedRectangle(cornerRadius: 4)
				.fill(Color.gray.opacity(0.3))
				.frame(width: 200, height: 14)

			HStack(spacing: 32) {
				RoundedRectangle(cornerRadius: 4)
					.fill(Color.gray.opacity(0.3))
					.frame(width: 60, height: 40)

				RoundedRectangle(cornerRadius: 4)
					.fill(Color.gray.opacity(0.3))
					.frame(width: 60, height: 40)
			}
		}
		.opacity(isAnimating ? 0.5 : 1.0)
		.animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isAnimating)
		.onAppear { isAnimating = true }
	}
}
