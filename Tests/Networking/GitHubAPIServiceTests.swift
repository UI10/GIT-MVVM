import XCTest
@testable import GIT_MVVM

final class GitHubAPIServiceTests: XCTestCase {
	func test_getUser_returnsUserOnSuccess() async throws {
		let (sut, client) = makeSUT()
		client.stub(.success((makeUserJSON(), makeHTTPResponse())))

		let user = try await sut.getUser(username: "octocat")

		XCTAssertEqual(user.login, "octocat")
		XCTAssertEqual(user.name, "The Octocat")
		XCTAssertEqual(user.followers, 100)
	}

	func test_getFollowers_returnsUsersOnSuccess() async throws {
		let (sut, client) = makeSUT()
		client.stub(.success((makeUserSummaryArrayJSON(count: 2), makeHTTPResponse())))

		let followers = try await sut.getFollowers(username: "octocat", page: 1, perPage: 20)

		XCTAssertEqual(followers.count, 2)
		XCTAssertEqual(followers.first?.login, "user1")
	}

	func test_getFollowing_returnsUsersOnSuccess() async throws {
		let (sut, client) = makeSUT()
		client.stub(.success((makeUserSummaryArrayJSON(count: 3), makeHTTPResponse())))

		let following = try await sut.getFollowing(username: "octocat", page: 1, perPage: 20)

		XCTAssertEqual(following.count, 3)
	}

	func test_getUser_requestsCorrectEndpoint() async throws {
		let (sut, client) = makeSUT()
		client.stub(.success((makeUserJSON(), makeHTTPResponse())))

		_ = try await sut.getUser(username: "testuser")

		XCTAssertEqual(client.requests.first?.url?.path, "/users/testuser")
	}

	func test_getFollowers_requestsCorrectEndpoint() async throws {
		let (sut, client) = makeSUT()
		client.stub(.success((makeUserSummaryArrayJSON(), makeHTTPResponse())))

		_ = try await sut.getFollowers(username: "testuser", page: 2, perPage: 10)

		let url = client.requests.first?.url
		XCTAssertEqual(url?.path, "/users/testuser/followers")
		XCTAssertTrue(url?.query?.contains("page=2") ?? false)
		XCTAssertTrue(url?.query?.contains("per_page=10") ?? false)
	}

	// MARK: - Helpers

	private func makeSUT() -> (GitHubAPIService, HTTPClientSpy) {
		let client = HTTPClientSpy()
		let store = RemoteStore(client: client)
		let sut = GitHubAPIService(store: store)
		return (sut, client)
	}
}
