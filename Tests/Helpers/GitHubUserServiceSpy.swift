import Foundation
@testable import GIT_MVVM

final class GitHubUserServiceSpy: GitHubUserService {
	private(set) var getUserCallCount = 0
	private(set) var getUserUsernames = [String]()
	var getUserResult: Result<GitHubUser, Error> = .failure(NSError(domain: "test", code: 0))

	func getUser(username: String) async throws -> GitHubUser {
		getUserCallCount += 1
		getUserUsernames.append(username)
		return try getUserResult.get()
	}
}
