import SwiftUI

public struct UserListView: View {
	@StateObject var viewModel: UserListViewModel
	let title: String
	let onUserTapped: (String) -> Void

	public var body: some View {
		Group {
			switch viewModel.state {
			case .idle, .isLoading:
				VStack(spacing: 16) {
					ProgressView()
						.tint(AppTheme.accentGreen)
						.scaleEffect(1.2)
					Text("Loading...")
						.font(.system(size: 14, weight: .medium))
						.foregroundStyle(AppTheme.subtitleGray)
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity)

			case .failure:
				ErrorRetryView(message: "Failed to load users") {
					Task { await viewModel.loadFirstPage() }
				}

			case .success(let users):
				if users.isEmpty {
					emptyView
				} else {
					userList(users)
				}
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background(AppTheme.darkBackground)
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
		.task { await viewModel.loadFirstPage() }
		.refreshable { await viewModel.loadFirstPage() }
	}

	private var emptyView: some View {
		VStack(spacing: 16) {
			ZStack {
				Circle()
					.fill(AppTheme.subtitleGray.opacity(0.1))
					.frame(width: 88, height: 88)

				Image(systemName: "person.2.slash")
					.font(.system(size: 36))
					.foregroundStyle(AppTheme.subtitleGray)
			}

			VStack(spacing: 6) {
				Text("No Users")
					.font(.system(size: 20, weight: .bold, design: .rounded))
					.foregroundStyle(.white)

				Text("This list is empty")
					.font(.system(size: 14, weight: .medium))
					.foregroundStyle(AppTheme.subtitleGray)
			}
		}
		.frame(maxWidth: .infinity, maxHeight: .infinity)
	}

	private func userList(_ users: [UserSummary]) -> some View {
		ScrollView {
			LazyVStack(spacing: 8) {
				ForEach(users) { user in
					Button {
						onUserTapped(user.login)
					} label: {
						UserSummaryRow(user: user)
					}
					.buttonStyle(ScaleButtonStyle())
					.task {
						await viewModel.loadNextPageIfNeeded(currentItem: user)
					}
				}
			}
			.padding(.horizontal, 16)
			.padding(.top, 8)
		}
	}
}
