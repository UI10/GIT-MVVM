import Foundation

public final class GitHubAPIService: GitHubUserService, FollowersService, FollowingService {
	private let store: RemoteStore

	public init(store: RemoteStore) {
		self.store = store
	}

	public func getUser(username: String) async throws -> GitHubUser {
		let remote: RemoteGitHubUser = try await store.get(for: UserEndpoint(username: username))
		return remote.toModel
	}

	public func getFollowers(username: String, page: Int, perPage: Int) async throws -> [UserSummary] {
		let remote: [RemoteUserSummary] = try await store.get(
			for: FollowersEndpoint(username: username, page: page, perPage: perPage)
		)
		return remote.map(\.toModel)
	}

	public func getFollowing(username: String, page: Int, perPage: Int) async throws -> [UserSummary] {
		let remote: [RemoteUserSummary] = try await store.get(
			for: FollowingEndpoint(username: username, page: page, perPage: perPage)
		)
		return remote.map(\.toModel)
	}
}
