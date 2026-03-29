import SwiftUI

enum AppTheme {
	static let accentGreen = Color(red: 0.18, green: 0.80, blue: 0.44)
	static let darkBackground = Color(red: 0.05, green: 0.05, blue: 0.08)
	static let cardBackground = Color(red: 0.10, green: 0.10, blue: 0.14)
	static let cardBorder = Color.white.opacity(0.06)
	static let subtitleGray = Color(red: 0.60, green: 0.60, blue: 0.65)
	static let avatarPlaceholder = Color(red: 0.15, green: 0.15, blue: 0.20)

	static let githubGradient = LinearGradient(
		colors: [
			Color(red: 0.18, green: 0.80, blue: 0.44),
			Color(red: 0.10, green: 0.55, blue: 0.85)
		],
		startPoint: .topLeading,
		endPoint: .bottomTrailing
	)

	static let cardShadow = Color.black.opacity(0.25)
}
