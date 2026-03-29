import Foundation
@testable import GIT_MVVM

final class GitHubUserCacheSpy: GitHubUserCache {
	private(set) var savedUsers = [GitHubUser]()
	private(set) var loadUserUsernames = [String]()
	var loadUserResult: Result<GitHubUser, Error> = .failure(PersistenceError.notFound)

	func save(user: GitHubUser) async throws {
		savedUsers.append(user)
	}

	func loadUser(username: String) async throws -> GitHubUser {
		loadUserUsernames.append(username)
		return try loadUserResult.get()
	}
}
