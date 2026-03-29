import SwiftUI

struct UserSummaryRow: View {
	let user: UserSummary

	var body: some View {
		HStack(spacing: 12) {
			AsyncImage(url: user.avatarURL) { image in
				image.resizable().scaledToFill()
			} placeholder: {
				Color.gray.opacity(0.3)
			}
			.frame(width: 44, height: 44)
			.clipShape(Circle())

			Text(user.login)
				.font(.body)

			Spacer()
		}
		.padding(.vertical, 4)
	}
}
