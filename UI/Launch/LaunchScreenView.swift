import SwiftUI

struct LaunchScreenView: View {
	@State private var logoScale: CGFloat = 0.4
	@State private var logoOpacity: Double = 0
	@State private var ringRotation: Double = 0
	@State private var ringScale: CGFloat = 0.6
	@State private var ringOpacity: Double = 0
	@State private var titleOffset: CGFloat = 30
	@State private var titleOpacity: Double = 0
	@State private var subtitleOpacity: Double = 0
	@State private var pulseScale: CGFloat = 1.0
	@State private var backgroundGlow: Double = 0

	var body: some View {
		ZStack {
			background
			glowEffect
			content
		}
		.onAppear { runAnimations() }
	}

	private var background: some View {
		Color.black
			.ignoresSafeArea()
	}

	private var glowEffect: some View {
		Circle()
			.fill(
				RadialGradient(
					colors: [
						AppTheme.accentGreen.opacity(0.15 * backgroundGlow),
						Color.clear
					],
					center: .center,
					startRadius: 20,
					endRadius: 250
				)
			)
			.frame(width: 500, height: 500)
			.blur(radius: 60)
	}

	private var content: some View {
		VStack(spacing: 0) {
			Spacer()

			ZStack {
				// Animated ring
				Circle()
					.strokeBorder(
						AngularGradient(
							colors: [
								AppTheme.accentGreen,
								AppTheme.accentGreen.opacity(0.3),
								Color(red: 0.10, green: 0.55, blue: 0.85),
								Color(red: 0.10, green: 0.55, blue: 0.85).opacity(0.3),
								AppTheme.accentGreen
							],
							center: .center
						),
						lineWidth: 3
					)
					.frame(width: 130, height: 130)
					.rotationEffect(.degrees(ringRotation))
					.scaleEffect(ringScale)
					.opacity(ringOpacity)

				// Logo
				ZStack {
					Circle()
						.fill(Color.white)
						.frame(width: 90, height: 90)
						.shadow(color: AppTheme.accentGreen.opacity(0.4), radius: 20)

					GitHubLogoShape()
						.fill(Color.black)
						.frame(width: 54, height: 54)
				}
				.scaleEffect(logoScale * pulseScale)
				.opacity(logoOpacity)
			}

			VStack(spacing: 8) {
				Text("GitHub Explorer")
					.font(.system(size: 28, weight: .bold, design: .rounded))
					.foregroundStyle(
						LinearGradient(
							colors: [.white, Color(white: 0.78)],
							startPoint: .leading,
							endPoint: .trailing
						)
					)
					.offset(y: titleOffset)
					.opacity(titleOpacity)

				Text("Discover developers worldwide")
					.font(.system(size: 15, weight: .medium, design: .rounded))
					.foregroundStyle(AppTheme.subtitleGray)
					.opacity(subtitleOpacity)
			}
			.padding(.top, 32)

			Spacer()
			Spacer()
		}
	}

	private func runAnimations() {
		// Background glow
		withAnimation(.easeIn(duration: 0.8)) {
			backgroundGlow = 1.0
		}

		// Logo appears
		withAnimation(.spring(response: 0.7, dampingFraction: 0.6)) {
			logoScale = 1.0
			logoOpacity = 1.0
		}

		// Ring appears and starts spinning
		withAnimation(.easeOut(duration: 0.5).delay(0.2)) {
			ringScale = 1.0
			ringOpacity = 1.0
		}
		withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
			ringRotation = 360
		}

		// Title slides up
		withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.35)) {
			titleOffset = 0
			titleOpacity = 1.0
		}

		// Subtitle fades in
		withAnimation(.easeIn(duration: 0.4).delay(0.55)) {
			subtitleOpacity = 1.0
		}

		// Gentle pulse on logo
		withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(0.8)) {
			pulseScale = 1.05
		}
	}
}

// MARK: - GitHub Logo Shape

struct GitHubLogoShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let w = rect.width
		let h = rect.height
		let cx = rect.midX
		let cy = rect.midY

		// Simplified GitHub octocat silhouette (circle body)
		let radius = min(w, h) / 2

		// Main circle
		path.addEllipse(in: CGRect(
			x: cx - radius,
			y: cy - radius,
			width: radius * 2,
			height: radius * 2
		))

		// Left ear
		path.move(to: CGPoint(x: cx - radius * 0.62, y: cy - radius * 0.78))
		path.addLine(to: CGPoint(x: cx - radius * 0.88, y: cy - radius * 1.15))
		path.addLine(to: CGPoint(x: cx - radius * 0.35, y: cy - radius * 0.88))
		path.closeSubpath()

		// Right ear
		path.move(to: CGPoint(x: cx + radius * 0.62, y: cy - radius * 0.78))
		path.addLine(to: CGPoint(x: cx + radius * 0.88, y: cy - radius * 1.15))
		path.addLine(to: CGPoint(x: cx + radius * 0.35, y: cy - radius * 0.88))
		path.closeSubpath()

		// Tail
		path.move(to: CGPoint(x: cx - radius * 0.35, y: cy + radius * 0.95))
		path.addQuadCurve(
			to: CGPoint(x: cx - radius * 0.70, y: cy + radius * 0.50),
			control: CGPoint(x: cx - radius * 0.75, y: cy + radius * 0.95)
		)

		return path
	}
}
