import Foundation

final class GitHubUserServiceCacheDecorator: GitHubUserService {
	private let decoratee: GitHubUserService
	private let cache: GitHubUserCache

	init(decoratee: GitHubUserService, cache: GitHubUserCache) {
		self.decoratee = decoratee
		self.cache = cache
	}

	func getUser(username: String) async throws -> GitHubUser {
		let user = try await decoratee.getUser(username: username)
		try? await cache.save(user: user)
		return user
	}
}
