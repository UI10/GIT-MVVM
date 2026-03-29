import Foundation

final class AppFactory {
	private let httpClient: HTTPClient
	private let remoteStore: RemoteStore
	private let apiService: GitHubAPIService

	init() {
		self.httpClient = URLSessionHTTPClient()
		self.remoteStore = RemoteStore(client: httpClient)
		self.apiService = GitHubAPIService(store: remoteStore)
	}

	var userService: GitHubUserService {
		apiService
	}

	var followersService: FollowersService {
		apiService
	}

	var followingService: FollowingService {
		apiService
	}

	func makeSearchUserViewModel() -> SearchUserViewModel {
		SearchUserViewModel(service: userService)
	}

	func makeUserProfileViewModel(username: String) -> UserProfileViewModel {
		UserProfileViewModel(input: .username(username), service: userService)
	}

	func makeUserProfileViewModel(user: GitHubUser) -> UserProfileViewModel {
		UserProfileViewModel(input: .preloaded(user), service: userService)
	}

	func makeFollowersViewModel(username: String) -> UserListViewModel {
		UserListViewModel(username: username) { [followersService] username, page, perPage in
			try await followersService.getFollowers(username: username, page: page, perPage: perPage)
		}
	}

	func makeFollowingViewModel(username: String) -> UserListViewModel {
		UserListViewModel(username: username) { [followingService] username, page, perPage in
			try await followingService.getFollowing(username: username, page: page, perPage: perPage)
		}
	}
}
