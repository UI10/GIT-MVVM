import XCTest
@testable import GIT_MVVM

final class GitHubUserServiceCacheDecoratorTests: XCTestCase {
	func test_getUser_returnsUserFromDecoratee() async throws {
		let (sut, service, _) = makeSUT()
		let user = makeUser()
		service.getUserResult = .success(user)

		let result = try await sut.getUser(username: "octocat")

		XCTAssertEqual(result, user)
	}

	func test_getUser_cachesUserOnSuccess() async throws {
		let (sut, service, cache) = makeSUT()
		let user = makeUser()
		service.getUserResult = .success(user)

		_ = try await sut.getUser(username: "octocat")

		XCTAssertEqual(cache.savedUsers, [user])
	}

	func test_getUser_doesNotCacheOnFailure() async {
		let (sut, _, cache) = makeSUT()

		_ = try? await sut.getUser(username: "octocat")

		XCTAssertTrue(cache.savedUsers.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT() -> (GitHubUserServiceCacheDecorator, GitHubUserServiceSpy, GitHubUserCacheSpy) {
		let service = GitHubUserServiceSpy()
		let cache = GitHubUserCacheSpy()
		let sut = GitHubUserServiceCacheDecorator(decoratee: service, cache: cache)
		return (sut, service, cache)
	}
}
