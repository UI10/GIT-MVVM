import SwiftUI

struct SearchFlowView: View {
	@StateObject private var flow = Flow<SearchRoute>()
	let factory: AppFactory

	var body: some View {
		NavigationStack(path: $flow.path) {
			SearchUserView(
				viewModel: factory.makeSearchUserViewModel(),
				onUserTapped: { user in
					flow.append(.profile(user.login))
				}
			)
			.navigationDestination(for: SearchRoute.self) { route in
				switch route {
				case .profile(let username):
					UserProfileView(
						viewModel: factory.makeUserProfileViewModel(username: username),
						onFollowersTapped: { login in
							flow.append(.followers(login))
						},
						onFollowingTapped: { login in
							flow.append(.following(login))
						}
					)

				case .followers(let username):
					UserListView(
						viewModel: factory.makeFollowersViewModel(username: username),
						title: "Followers",
						onUserTapped: { login in
							flow.append(.profile(login))
						}
					)

				case .following(let username):
					UserListView(
						viewModel: factory.makeFollowingViewModel(username: username),
						title: "Following",
						onUserTapped: { login in
							flow.append(.profile(login))
						}
					)
				}
			}
		}
	}
}
