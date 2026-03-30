import SwiftUI

struct SearchFlowView: View {
	@StateObject private var flow = Flow<SearchRoute>()
	@StateObject private var searchViewModel: SearchUserViewModel
	let factory: AppFactory

	init(factory: AppFactory) {
		self.factory = factory
		self._searchViewModel = StateObject(wrappedValue: factory.makeSearchUserViewModel())
	}

	var body: some View {
		NavigationStack(path: $flow.path) {
			SearchUserView(
				viewModel: searchViewModel,
				onUserTapped: { user in
					flow.append(.profile(user))
				}
			)
			.navigationDestination(for: SearchRoute.self) { route in
				switch route {
				case .profile(let user):
					UserProfileView(
						viewModel: factory.makeUserProfileViewModel(user: user),
						onFollowersTapped: { login in
							flow.append(.followers(login))
						},
						onFollowingTapped: { login in
							flow.append(.following(login))
						}
					)

				case .profileByUsername(let username):
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
							flow.append(.profileByUsername(login))
						}
					)

				case .following(let username):
					UserListView(
						viewModel: factory.makeFollowingViewModel(username: username),
						title: "Following",
						onUserTapped: { login in
							flow.append(.profileByUsername(login))
						}
					)
				}
			}
		}
		.background(AppTheme.darkBackground.ignoresSafeArea())
		.toolbarBackground(AppTheme.darkBackground, for: .navigationBar)
	}
}
