import SwiftUI

public struct SearchUserView: View {
	@StateObject var viewModel: SearchUserViewModel
	let onUserTapped: (GitHubUser) -> Void

	@State private var idleAnimation = false

	public var body: some View {
		ZStack {
			AppTheme.darkBackground.ignoresSafeArea()
			searchContent
		}
		.searchable(text: $viewModel.searchText, prompt: "Search GitHub username")
		.onSubmit(of: .search) {
			Task { await viewModel.searchUser() }
		}
		.navigationTitle("GitHub Explorer")
	}

	@ViewBuilder
	private var searchContent: some View {
		switch viewModel.state {
		case .idle:
			idleView

		case .isLoading:
			SkeletonView()
				.frame(maxHeight: .infinity)
				.transition(.opacity)

		case .failure(.notFound):
			NotFoundView(username: viewModel.searchText)
				.frame(maxHeight: .infinity)
				.transition(.opacity)

		case .failure(.serverError):
			ErrorRetryView(message: "Could not connect to GitHub") {
				Task { await viewModel.searchUser() }
			}
			.frame(maxHeight: .infinity)

		case .success(let user):
			profileCard(for: user)
				.transition(.asymmetric(
					insertion: .move(edge: .bottom).combined(with: .opacity),
					removal: .opacity
				))
		}
	}

	private var idleView: some View {
		VStack(spacing: 20) {
			ZStack {
				Circle()
					.fill(AppTheme.accentGreen.opacity(0.08))
					.frame(width: 100, height: 100)
					.scaleEffect(idleAnimation ? 1.15 : 1.0)
					.opacity(idleAnimation ? 0.4 : 0.8)

				Image(systemName: "magnifyingglass")
					.font(.system(size: 38, weight: .medium))
					.foregroundStyle(AppTheme.accentGreen)
			}

			VStack(spacing: 8) {
				Text("Search GitHub Users")
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundStyle(.white)

				Text("Enter a username to explore profiles,\nfollowers, and connections")
					.font(.system(size: 14, weight: .medium))
					.foregroundStyle(AppTheme.subtitleGray)
					.multilineTextAlignment(.center)
					.lineSpacing(3)
			}
		}
		.frame(maxHeight: .infinity)
		.onAppear {
			withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
				idleAnimation = true
			}
		}
	}

	private func profileCard(for user: GitHubUser) -> some View {
		Button {
			onUserTapped(user)
		} label: {
			HStack(spacing: 16) {
				AsyncImage(url: user.avatarURL) { image in
					image.resizable().scaledToFill()
				} placeholder: {
					AppTheme.avatarPlaceholder
				}
				.frame(width: 64, height: 64)
				.clipShape(Circle())
				.overlay(Circle().strokeBorder(AppTheme.accentGreen.opacity(0.4), lineWidth: 2))

				VStack(alignment: .leading, spacing: 4) {
					if let name = user.name {
						Text(name)
							.font(.system(size: 17, weight: .semibold, design: .rounded))
							.foregroundStyle(.white)
					}
					Text("@\(user.login)")
						.font(.system(size: 14, weight: .medium, design: .monospaced))
						.foregroundStyle(AppTheme.accentGreen)
					if let bio = user.bio {
						Text(bio)
							.font(.system(size: 13))
							.foregroundStyle(AppTheme.subtitleGray)
							.lineLimit(2)
					}
				}

				Spacer()

				Image(systemName: "chevron.right.circle.fill")
					.font(.system(size: 24))
					.foregroundStyle(AppTheme.accentGreen.opacity(0.6))
			}
			.padding(16)
			.background(
				RoundedRectangle(cornerRadius: 16)
					.fill(AppTheme.cardBackground)
					.overlay(
						RoundedRectangle(cornerRadius: 16)
							.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
					)
					.shadow(color: AppTheme.cardShadow, radius: 8, y: 4)
			)
			.padding(.horizontal, 20)
		}
		.buttonStyle(ScaleButtonStyle())
		.frame(maxHeight: .infinity, alignment: .top)
		.padding(.top, 16)
	}
}
