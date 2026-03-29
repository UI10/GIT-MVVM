import SwiftUI

struct UserSummaryRow: View {
	let user: UserSummary

	var body: some View {
		HStack(spacing: 14) {
			AsyncImage(url: user.avatarURL) { image in
				image.resizable().scaledToFill()
			} placeholder: {
				AppTheme.avatarPlaceholder
			}
			.frame(width: 48, height: 48)
			.clipShape(Circle())
			.overlay(
				Circle()
					.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
			)

			VStack(alignment: .leading, spacing: 2) {
				Text(user.login)
					.font(.system(size: 16, weight: .semibold, design: .rounded))
					.foregroundStyle(.white)

				Text("View profile")
					.font(.system(size: 12, weight: .medium))
					.foregroundStyle(AppTheme.subtitleGray)
			}

			Spacer()

			Image(systemName: "chevron.right")
				.font(.system(size: 13, weight: .semibold))
				.foregroundStyle(AppTheme.subtitleGray.opacity(0.5))
		}
		.padding(12)
		.background(
			RoundedRectangle(cornerRadius: 14)
				.fill(AppTheme.cardBackground)
				.overlay(
					RoundedRectangle(cornerRadius: 14)
						.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
				)
		)
	}
}
