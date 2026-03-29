import SwiftUI

struct SkeletonView: View {
	@State private var shimmerOffset: CGFloat = -1.0

	var body: some View {
		VStack(spacing: 20) {
			Circle()
				.fill(AppTheme.cardBackground)
				.frame(width: 110, height: 110)
				.overlay(shimmerOverlay.clipShape(Circle()))

			VStack(spacing: 10) {
				skeletonBar(width: 160, height: 22)
				skeletonBar(width: 110, height: 16)
			}

			skeletonBar(width: 220, height: 14)
				.padding(.top, 4)

			HStack(spacing: 40) {
				skeletonPill(width: 70, height: 44)
				skeletonPill(width: 70, height: 44)
			}
			.padding(.top, 8)
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.onAppear {
			withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
				shimmerOffset = 2.0
			}
		}
	}

	private func skeletonBar(width: CGFloat, height: CGFloat) -> some View {
		RoundedRectangle(cornerRadius: height / 2)
			.fill(AppTheme.cardBackground)
			.frame(width: width, height: height)
			.overlay(shimmerOverlay.clipShape(RoundedRectangle(cornerRadius: height / 2)))
	}

	private func skeletonPill(width: CGFloat, height: CGFloat) -> some View {
		RoundedRectangle(cornerRadius: 10)
			.fill(AppTheme.cardBackground)
			.frame(width: width, height: height)
			.overlay(shimmerOverlay.clipShape(RoundedRectangle(cornerRadius: 10)))
	}

	private var shimmerOverlay: some View {
		GeometryReader { geo in
			LinearGradient(
				colors: [
					Color.clear,
					Color.white.opacity(0.06),
					Color.clear
				],
				startPoint: .leading,
				endPoint: .trailing
			)
			.frame(width: geo.size.width * 0.6)
			.offset(x: geo.size.width * shimmerOffset)
		}
	}
}
