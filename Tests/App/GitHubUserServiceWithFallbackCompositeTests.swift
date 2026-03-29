import XCTest
@testable import GIT_MVVM

final class GitHubUserServiceWithFallbackCompositeTests: XCTestCase {
	func test_getUser_returnsPrimaryResultOnSuccess() async throws {
		let (sut, primary, _) = makeSUT()
		let user = makeUser(login: "primary")
		primary.getUserResult = .success(user)

		let result = try await sut.getUser(username: "octocat")

		XCTAssertEqual(result.login, "primary")
	}

	func test_getUser_returnsSecondaryResultOnPrimaryFailure() async throws {
		let (sut, _, secondary) = makeSUT()
		let user = makeUser(login: "secondary")
		secondary.getUserResult = .success(user)

		let result = try await sut.getUser(username: "octocat")

		XCTAssertEqual(result.login, "secondary")
	}

	func test_getUser_throwsWhenBothFail() async {
		let (sut, _, _) = makeSUT()

		do {
			_ = try await sut.getUser(username: "octocat")
			XCTFail("Expected error")
		} catch {
			// Expected
		}
	}

	// MARK: - Helpers

	private func makeSUT() -> (GitHubUserServiceWithFallbackComposite, GitHubUserServiceSpy, GitHubUserServiceSpy) {
		let primary = GitHubUserServiceSpy()
		let secondary = GitHubUserServiceSpy()
		let sut = GitHubUserServiceWithFallbackComposite(primary: primary, secondary: secondary)
		return (sut, primary, secondary)
	}
}
