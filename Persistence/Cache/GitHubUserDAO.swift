import Foundation

public final class GitHubUserDAO: GitHubUserService, GitHubUserCache {
	private let store: LocalStore
	private let maxCacheAge: TimeInterval

	public init(store: LocalStore, maxCacheAge: TimeInterval = 3600) {
		self.store = store
		self.maxCacheAge = maxCacheAge
	}

	// MARK: - GitHubUserService

	public func getUser(username: String) async throws -> GitHubUser {
		try await loadUser(username: username)
	}

	// MARK: - GitHubUserCache

	public func save(user: GitHubUser) async throws {
		try await store.write(user)
	}

	public func loadUser(username: String) async throws -> GitHubUser {
		let predicate = NSPredicate(format: "login == %@", username)
		let user: GitHubUser = try await store.read(predicate: predicate)
		return user
	}
}
