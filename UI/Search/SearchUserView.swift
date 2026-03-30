import SwiftUI

public struct SearchUserView: View {
	@StateObject var viewModel: SearchUserViewModel
	let onUserTapped: (GitHubUser) -> Void

	@State private var cardAppeared = false
	@FocusState private var isSearchFocused: Bool

	public var body: some View {
		VStack(spacing: 0) {
			header

			searchBar

			content
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(AppTheme.darkBackground)
		.onTapGesture { isSearchFocused = false }
		.navigationBarHidden(true)
	}

	// MARK: - Header

	private var header: some View {
		HStack(spacing: 0) {
			Text("GitHub")
				.font(.system(size: 28, weight: .bold, design: .rounded))
				.foregroundColor(AppTheme.accentGreen)

			Text(" Explorer")
				.font(.system(size: 28, weight: .bold, design: .rounded))
				.foregroundColor(.white)
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.padding(.horizontal, 20)
		.padding(.top, 8)
		.padding(.bottom, 12)
	}

	// MARK: - Search Bar

	private var searchBar: some View {
		HStack(spacing: 12) {
			Button {
				cardAppeared = false
				isSearchFocused = false
				Task { await viewModel.searchUser() }
			} label: {
				Image(systemName: "magnifyingglass")
					.font(.system(size: 16, weight: .medium))
					.foregroundStyle(isSearchFocused ? AppTheme.accentGreen : AppTheme.subtitleGray)
			}
			.disabled(viewModel.searchText.isEmpty)

			TextField("Search username...", text: $viewModel.searchText)
				.font(.system(size: 16, weight: .medium))
				.foregroundStyle(.white)
				.autocorrectionDisabled()
				.textInputAutocapitalization(.never)
				.focused($isSearchFocused)
				.submitLabel(.search)
				.onSubmit {
					cardAppeared = false
					Task { await viewModel.searchUser() }
				}

			if !viewModel.searchText.isEmpty {
				Button {
					viewModel.searchText = ""
				} label: {
					Image(systemName: "xmark.circle.fill")
						.font(.system(size: 16))
						.foregroundStyle(AppTheme.subtitleGray)
				}
			}
		}
		.padding(.horizontal, 16)
		.padding(.vertical, 12)
		.background(
			RoundedRectangle(cornerRadius: 14)
				.fill(AppTheme.cardBackground)
				.overlay(
					RoundedRectangle(cornerRadius: 14)
						.strokeBorder(
							isSearchFocused ? AppTheme.accentGreen.opacity(0.5) : AppTheme.cardBorder,
							lineWidth: 1
						)
				)
		)
		.padding(.horizontal, 20)
		.animation(.easeInOut(duration: 0.2), value: isSearchFocused)
	}

	// MARK: - Content

	@ViewBuilder
	private var content: some View {
		switch viewModel.state {
		case .idle:
			idleView

		case .isLoading:
			SkeletonView()
				.frame(maxWidth: .infinity, maxHeight: .infinity)

		case .failure(.notFound):
			NotFoundView(username: viewModel.searchText)
				.frame(maxWidth: .infinity, maxHeight: .infinity)

		case .failure(.serverError):
			ErrorRetryView(message: "Could not connect to GitHub") {
				Task { await viewModel.searchUser() }
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)

		case .success(let user):
			successView(for: user)
		}
	}

	// MARK: - Idle

	private var idleView: some View {
		ScrollView {
			VStack(spacing: 0) {
				// Suggestion chips
				VStack(alignment: .leading, spacing: 12) {
					Text("POPULAR USERS")
						.font(.system(size: 11, weight: .bold))
						.foregroundStyle(AppTheme.subtitleGray.opacity(0.5))
						.tracking(1.5)

					LazyVGrid(columns: [
						GridItem(.flexible(), spacing: 10),
						GridItem(.flexible(), spacing: 10),
						GridItem(.flexible(), spacing: 10)
					], spacing: 10) {
						suggestionChip("octocat", icon: "cat.fill")
						suggestionChip("torvalds", icon: "terminal.fill")
						suggestionChip("mojombo", icon: "hammer.fill")
						suggestionChip("defunkt", icon: "wrench.fill")
						suggestionChip("pjhyett", icon: "gearshape.fill")
						suggestionChip("wycats", icon: "chevron.left.forwardslash.chevron.right")
					}
				}
				.padding(.horizontal, 20)
				.padding(.top, 24)

				// Divider
				Rectangle()
					.fill(AppTheme.cardBorder)
					.frame(height: 1)
					.padding(.horizontal, 20)
					.padding(.top, 28)

				// Features
				VStack(alignment: .leading, spacing: 12) {
					Text("WHAT YOU CAN DO")
						.font(.system(size: 11, weight: .bold))
						.foregroundStyle(AppTheme.subtitleGray.opacity(0.5))
						.tracking(1.5)

					featureRow(
						icon: "person.crop.circle.fill",
						color: AppTheme.accentGreen,
						title: "View Profiles",
						subtitle: "Avatar, bio, follower counts"
					)
					featureRow(
						icon: "person.2.fill",
						color: Color(red: 0.10, green: 0.55, blue: 0.85),
						title: "Browse Followers",
						subtitle: "Paginated follower & following lists"
					)
					featureRow(
						icon: "arrow.triangle.branch",
						color: Color(red: 0.65, green: 0.45, blue: 0.95),
						title: "Explore Deeper",
						subtitle: "Tap any user to see their profile"
					)
				}
				.padding(.horizontal, 20)
				.padding(.top, 24)
			}
		}
		.scrollIndicators(.hidden)
		.scrollDismissesKeyboard(.interactively)
	}

	private func suggestionChip(_ username: String, icon: String) -> some View {
		Button {
			cardAppeared = false
			viewModel.searchText = username
			isSearchFocused = false
			Task { await viewModel.searchUser() }
		} label: {
			VStack(spacing: 8) {
				Image(systemName: icon)
					.font(.system(size: 16, weight: .medium))
					.foregroundStyle(AppTheme.accentGreen)

				Text(username)
					.font(.system(size: 12, weight: .semibold, design: .monospaced))
					.foregroundStyle(.white)
					.lineLimit(1)
					.minimumScaleFactor(0.8)
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 14)
			.background(
				RoundedRectangle(cornerRadius: 12)
					.fill(AppTheme.cardBackground)
					.overlay(
						RoundedRectangle(cornerRadius: 12)
							.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
					)
			)
		}
		.buttonStyle(ScaleButtonStyle())
	}

	private func featureRow(icon: String, color: Color, title: String, subtitle: String) -> some View {
		HStack(spacing: 14) {
			Image(systemName: icon)
				.font(.system(size: 18, weight: .medium))
				.foregroundStyle(color)
				.frame(width: 40, height: 40)
				.background(
					RoundedRectangle(cornerRadius: 10)
						.fill(color.opacity(0.12))
				)

			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.system(size: 15, weight: .semibold, design: .rounded))
					.foregroundStyle(.white)

				Text(subtitle)
					.font(.system(size: 13))
					.foregroundStyle(AppTheme.subtitleGray)
			}

			Spacer()

			Image(systemName: "chevron.right")
				.font(.system(size: 12, weight: .semibold))
				.foregroundStyle(AppTheme.subtitleGray.opacity(0.4))
		}
		.padding(14)
		.background(
			RoundedRectangle(cornerRadius: 14)
				.fill(AppTheme.cardBackground)
				.overlay(
					RoundedRectangle(cornerRadius: 14)
						.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
				)
		)
	}

	// MARK: - Success

	private func successView(for user: GitHubUser) -> some View {
		ScrollView {
			VStack(spacing: 0) {
				// Avatar
				ZStack {
					Circle()
						.fill(AppTheme.accentGreen.opacity(0.06))
						.frame(width: 140, height: 140)

					AsyncImage(url: user.avatarURL) { image in
						image.resizable().scaledToFill()
					} placeholder: {
						AppTheme.avatarPlaceholder
					}
					.frame(width: 110, height: 110)
					.clipShape(Circle())
					.overlay(
						Circle()
							.strokeBorder(AppTheme.githubGradient, lineWidth: 3)
					)
					.shadow(color: AppTheme.accentGreen.opacity(0.25), radius: 20)
				}
				.padding(.top, 24)
				.opacity(cardAppeared ? 1 : 0)
				.scaleEffect(cardAppeared ? 1 : 0.8)

				// Name and username
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
				.opacity(cardAppeared ? 1 : 0)
				.offset(y: cardAppeared ? 0 : 12)

				// Bio
				if let bio = user.bio {
					Text(bio)
						.font(.system(size: 15))
						.foregroundStyle(AppTheme.subtitleGray)
						.multilineTextAlignment(.center)
						.lineSpacing(4)
						.padding(.horizontal, 32)
						.padding(.top, 12)
						.opacity(cardAppeared ? 1 : 0)
				}

				// Stats
				HStack(spacing: 16) {
					statCard(count: user.followers, label: "Followers", icon: "person.2.fill")
					statCard(count: user.following, label: "Following", icon: "heart.fill")
				}
				.padding(.horizontal, 20)
				.padding(.top, 24)
				.opacity(cardAppeared ? 1 : 0)
				.offset(y: cardAppeared ? 0 : 16)

				// CTA
				Button {
					onUserTapped(user)
				} label: {
					HStack(spacing: 10) {
						Text("View Full Profile")
							.font(.system(size: 16, weight: .semibold, design: .rounded))
						Image(systemName: "arrow.right")
							.font(.system(size: 14, weight: .semibold))
					}
					.foregroundStyle(.white)
					.frame(maxWidth: .infinity)
					.padding(.vertical, 16)
					.background(
						RoundedRectangle(cornerRadius: 16)
							.fill(AppTheme.githubGradient)
							.shadow(color: AppTheme.accentGreen.opacity(0.3), radius: 12, y: 6)
					)
				}
				.buttonStyle(ScaleButtonStyle())
				.padding(.horizontal, 24)
				.padding(.top, 28)
				.opacity(cardAppeared ? 1 : 0)
				.offset(y: cardAppeared ? 0 : 20)

				// Info rows
				VStack(spacing: 10) {
					infoRow(icon: "number", label: "ID", value: "\(user.id)")
					infoRow(icon: "link", label: "Profile", value: "github.com/\(user.login)")
				}
				.padding(.horizontal, 20)
				.padding(.top, 24)
				.opacity(cardAppeared ? 1 : 0)
			}
		}
		.scrollIndicators(.hidden)
		.scrollDismissesKeyboard(.immediately)
		.onAppear {
			withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.1)) {
				cardAppeared = true
			}
		}
	}

	private func statCard(count: Int, label: String, icon: String) -> some View {
		VStack(spacing: 6) {
			HStack(spacing: 6) {
				Image(systemName: icon)
					.font(.system(size: 12, weight: .medium))
					.foregroundStyle(AppTheme.accentGreen)
				Text(formattedCount(count))
					.font(.system(size: 24, weight: .bold, design: .rounded))
					.foregroundStyle(.white)
			}
			Text(label)
				.font(.system(size: 13, weight: .medium))
				.foregroundStyle(AppTheme.subtitleGray)
		}
		.frame(maxWidth: .infinity)
		.padding(.vertical, 18)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(AppTheme.cardBackground)
				.overlay(
					RoundedRectangle(cornerRadius: 16)
						.strokeBorder(AppTheme.cardBorder, lineWidth: 1)
				)
		)
	}

	private func infoRow(icon: String, label: String, value: String) -> some View {
		HStack(spacing: 12) {
			Image(systemName: icon)
				.font(.system(size: 13, weight: .medium))
				.foregroundStyle(AppTheme.accentGreen)
				.frame(width: 30, height: 30)
				.background(Circle().fill(AppTheme.accentGreen.opacity(0.1)))

			Text(label)
				.font(.system(size: 14, weight: .medium))
				.foregroundStyle(AppTheme.subtitleGray)

			Spacer()

			Text(value)
				.font(.system(size: 14, weight: .semibold, design: .monospaced))
				.foregroundStyle(.white.opacity(0.8))
				.lineLimit(1)
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

	private func formattedCount(_ count: Int) -> String {
		if count >= 1_000_000 {
			return String(format: "%.1fM", Double(count) / 1_000_000)
		} else if count >= 1_000 {
			return String(format: "%.1fK", Double(count) / 1_000)
		}
		return "\(count)"
	}
}


#Preview {
    SearchUserView(viewModel: AppFactory().makeSearchUserViewModel(), onUserTapped: { _ in })
        .background(AppTheme.darkBackground.ignoresSafeArea())
}
