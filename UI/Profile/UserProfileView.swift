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
		.navigationTitle("Profile")
		.navigationBarTitleDisplayMode(.inline)
		.task { await viewModel.loadProfile() }
	}

	private func profileContent(for user: GitHubUser) -> some View {
		ScrollView {
			VStack(spacing: 20) {
				AsyncImage(url: user.avatarURL) { image in
					image.resizable().scaledToFill()
				} placeholder: {
					Color.gray.opacity(0.3)
				}
				.frame(width: 120, height: 120)
				.clipShape(Circle())

				VStack(spacing: 6) {
					if let name = user.name {
						Text(name)
							.font(.title2.bold())
					}

					Text(user.login)
						.font(.title3)
						.foregroundStyle(.secondary)
				}

				if let bio = user.bio {
					Text(bio)
						.font(.body)
						.foregroundStyle(.secondary)
						.multilineTextAlignment(.center)
						.padding(.horizontal, 32)
				}

				HStack(spacing: 48) {
					ProfileStatButton(count: user.followers, label: "Followers") {
						onFollowersTapped(user.login)
					}

					ProfileStatButton(count: user.following, label: "Following") {
						onFollowingTapped(user.login)
					}
				}
				.padding(.top, 8)
			}
			.padding(.top, 24)
		}
	}
}
