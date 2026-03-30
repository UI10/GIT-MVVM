import SwiftUI

public struct UserProfileView: View {
	@StateObject var viewModel: UserProfileViewModel
	let onFollowersTapped: (String) -> Void
	let onFollowingTapped: (String) -> Void

	public var body: some View {
		Group {
			switch viewModel.state {
			case .idle, .isLoading:
				SkeletonView()

			case .failure(.notFound):
				ErrorRetryView(message: "User not found") {
					Task { await viewModel.loadProfile() }
				}

			case .failure(.serverError):
				ErrorRetryView(message: "Something went wrong") {
					Task { await viewModel.loadProfile() }
				}

			case .success(let user):
				profileContent(for: user)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(AppTheme.darkBackground)
		.navigationTitle("Profile")
		.navigationBarTitleDisplayMode(.inline)
		.task { await viewModel.loadProfile() }
	}

	private func profileContent(for user: GitHubUser) -> some View {
		ScrollView {
			VStack(spacing: 0) {
				// Avatar with gradient ring
				ZStack {
					Circle()
						.fill(AppTheme.accentGreen.opacity(0.08))
						.frame(width: 150, height: 150)

					AsyncImage(url: user.avatarURL) { image in
						image.resizable().scaledToFill()
					} placeholder: {
						AppTheme.avatarPlaceholder(size: 36)
					}
					.frame(width: 120, height: 120)
					.clipShape(Circle())
					.overlay(
						Circle()
							.strokeBorder(
								AppTheme.githubGradient,
								lineWidth: 3
							)
					)
					.shadow(color: AppTheme.accentGreen.opacity(0.2), radius: 16)
				}
				.padding(.top, 24)

				// Name & username
				VStack(spacing: 6) {
					if let name = user.name {
						Text(name)
							.font(.system(size: 26, weight: .bold, design: .rounded))
							.foregroundStyle(.white)
					}

					Text("@\(user.login)")
						.font(.system(size: 16, weight: .medium, design: .monospaced))
						.foregroundStyle(AppTheme.accentGreen)
				}
				.padding(.top, 16)

				// Bio
				if let bio = user.bio {
					Text(bio)
						.font(.system(size: 15, weight: .regular))
						.foregroundStyle(AppTheme.subtitleGray)
						.multilineTextAlignment(.center)
						.lineSpacing(4)
						.padding(.horizontal, 40)
						.padding(.top, 12)
				}

				// Stats
				HStack(spacing: 16) {
					ProfileStatButton(count: user.followers, label: "Followers") {
						onFollowersTapped(user.login)
					}

					ProfileStatButton(count: user.following, label: "Following") {
						onFollowingTapped(user.login)
					}
				}
				.padding(.top, 28)

				// Info pills
				VStack(spacing: 12) {
					infoPill(icon: "person.fill", label: "User ID", value: "#\(user.id)")
				}
				.padding(.top, 28)
				.padding(.horizontal, 20)
			}
			.padding(.bottom, 40)
		}
	}

	private func infoPill(icon: String, label: String, value: String) -> some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 14, weight: .medium))
				.foregroundStyle(AppTheme.accentGreen)
				.frame(width: 32, height: 32)
				.background(
					Circle()
						.fill(AppTheme.accentGreen.opacity(0.1))
				)

			Text(label)
				.font(.system(size: 14, weight: .medium))
				.foregroundStyle(AppTheme.subtitleGray)

			Spacer()

			Text(value)
				.font(.system(size: 14, weight: .semibold, design: .monospaced))
				.foregroundStyle(.white)
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 12)
		.background(
			RoundedRectangle(cornerRadius: 12)
				.fill(AppTheme.cardBackground)
				.overlay(
					RoundedRectangle(cornerRadius: 12)
						.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
				)
		)
	}
}
