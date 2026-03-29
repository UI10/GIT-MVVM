import SwiftUI

public struct UserListView: View {
	@StateObject var viewModel: UserListViewModel
	let title: String
	let onUserTapped: (String) -> Void

	public var body: some View {
		Group {
			switch viewModel.state {
			case .idle, .isLoading:
				ProgressView()
					.frame(maxWidth: .infinity, maxHeight: .infinity)

			case .failure:
				ErrorRetryView(message: "Failed to load users") {
					Task { await viewModel.loadFirstPage() }
				}

			case .success(let users):
				if users.isEmpty {
					VStack(spacing: 12) {
						Image(systemName: "person.2.slash")
							.font(.system(size: 48))
							.foregroundStyle(.secondary)
						Text("No users")
							.font(.title3.bold())
						Text("This list is empty")
							.font(.subheadline)
							.foregroundStyle(.secondary)
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
				} else {
					userList(users)
				}
			}
		}
		.navigationTitle(title)
		.navigationBarTitleDisplayMode(.inline)
		.task { await viewModel.loadFirstPage() }
		.refreshable { await viewModel.loadFirstPage() }
	}

	private func userList(_ users: [UserSummary]) -> some View {
		List(users) { user in
			Button {
				onUserTapped(user.login)
			} label: {
				UserSummaryRow(user: user)
			}
			.buttonStyle(.plain)
			.task {
				await viewModel.loadNextPageIfNeeded(currentItem: user)
			}
		}
		.listStyle(.plain)
	}
}
