import SwiftUI

struct ProfileStatButton: View {
	let count: Int
	let label: String
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			VStack(spacing: 4) {
				Text(formattedCount)
					.font(.system(size: 22, weight: .bold, design: .rounded))
					.foregroundStyle(.white)

				Text(label)
					.font(.system(size: 13, weight: .medium))
					.foregroundStyle(AppTheme.subtitleGray)
			}
			.frame(minWidth: 80)
			.padding(.vertical, 12)
			.padding(.horizontal, 16)
			.background(
				RoundedRectangle(cornerRadius: 14)
					.fill(AppTheme.cardBackground)
					.overlay(
						RoundedRectangle(cornerRadius: 14)
							.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
					)
			)
		}
		.buttonStyle(ScaleButtonStyle())
	}

	private var formattedCount: String {
		if count >= 1_000_000 {
			return String(format: "%.1fM", Double(count) / 1_000_000)
		} else if count >= 1_000 {
			return String(format: "%.1fK", Double(count) / 1_000)
		}
		return "\(count)"
	}
}

struct ScaleButtonStyle: ButtonStyle {
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.scaleEffect(configuration.isPressed ? 0.94 : 1.0)
			.animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
	}
}
