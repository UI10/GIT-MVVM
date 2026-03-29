import XCTest
@testable import GIT_MVVM

final class EndpointTests: XCTestCase {
	func test_userEndpoint_createsCorrectRequest() throws {
		let endpoint = UserEndpoint(username: "octocat")
		let request = try endpoint.createURLRequest()

		XCTAssertEqual(request.url?.scheme, "https")
		XCTAssertEqual(request.url?.host, "api.github.com")
		XCTAssertEqual(request.url?.path, "/users/octocat")
		XCTAssertEqual(request.httpMethod, "GET")
	}

	func test_followersEndpoint_createsCorrectRequest() throws {
		let endpoint = FollowersEndpoint(username: "octocat", page: 1, perPage: 20)
		let request = try endpoint.createURLRequest()

		XCTAssertEqual(request.url?.path, "/users/octocat/followers")
		XCTAssertTrue(request.url?.query?.contains("page=1") ?? false)
		XCTAssertTrue(request.url?.query?.contains("per_page=20") ?? false)
	}

	func test_followingEndpoint_createsCorrectRequest() throws {
		let endpoint = FollowingEndpoint(username: "octocat", page: 2, perPage: 10)
		let request = try endpoint.createURLRequest()

		XCTAssertEqual(request.url?.path, "/users/octocat/following")
		XCTAssertTrue(request.url?.query?.contains("page=2") ?? false)
		XCTAssertTrue(request.url?.query?.contains("per_page=10") ?? false)
	}
}
