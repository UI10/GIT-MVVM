import SwiftUI

public struct SearchUserView: View {
	@StateObject var viewModel: SearchUserViewModel
	let onUserTapped: (GitHubUser) -> Void

	public var body: some View {
		VStack {
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
			VStack(spacing: 12) {
				Image(systemName: "magnifyingglass")
					.font(.system(size: 48))
					.foregroundStyle(.secondary)
				Text("Search for a user")
					.font(.title3.bold())
				Text("Enter a GitHub username to get started")
					.font(.subheadline)
					.foregroundStyle(.secondary)
			}
			.frame(maxHeight: .infinity)

		case .isLoading:
			SkeletonView()
				.frame(maxHeight: .infinity)

		case .failure(.notFound):
			NotFoundView(username: viewModel.searchText)
				.frame(maxHeight: .infinity)

		case .failure(.serverError):
			ErrorRetryView(message: "Something went wrong") {
				Task { await viewModel.searchUser() }
			}
			.frame(maxHeight: .infinity)

		case .success(let user):
			profileCard(for: user)
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
					Color.gray.opacity(0.3)
				}
				.frame(width: 64, height: 64)
				.clipShape(Circle())

				VStack(alignment: .leading, spacing: 4) {
					if let name = user.name {
						Text(name)
							.font(.headline)
					}
					Text(user.login)
						.font(.subheadline)
						.foregroundStyle(.secondary)
					if let bio = user.bio {
						Text(bio)
							.font(.caption)
							.foregroundStyle(.secondary)
							.lineLimit(2)
					}
				}

				Spacer()

				Image(systemName: "chevron.right")
					.foregroundStyle(.secondary)
			}
			.padding()
			.background(Color(.secondarySystemBackground))
			.cornerRadius(12)
			.padding(.horizontal)
		}
		.buttonStyle(.plain)
		.frame(maxHeight: .infinity, alignment: .top)
		.padding(.top)
	}
}
