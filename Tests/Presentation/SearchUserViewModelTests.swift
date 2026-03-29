import XCTest
@testable import GIT_MVVM

@MainActor
final class SearchUserViewModelTests: XCTestCase {
	func test_init_startsInIdleState() {
		let (sut, _) = makeSUT()

		XCTAssertEqual(sut.state, .idle)
	}

	func test_searchUser_setsLoadingThenSuccess() async {
		let (sut, service) = makeSUT()
		let user = makeUser()
		service.getUserResult = .success(user)
		sut.searchText = "octocat"

		let spy = PublisherSpy(sut.$state)
		await sut.searchUser()

		XCTAssertEqual(spy.values, [.idle, .isLoading, .success(user)])
	}

	func test_searchUser_setsLoadingThenNotFoundOnNotFoundError() async {
		let (sut, service) = makeSUT()
		service.getUserResult = .failure(NetworkError.notFound)
		sut.searchText = "nonexistent"

		let spy = PublisherSpy(sut.$state)
		await sut.searchUser()

		XCTAssertEqual(spy.values, [.idle, .isLoading, .failure(.notFound)])
	}

	func test_searchUser_setsLoadingThenServerErrorOnOtherError() async {
		let (sut, service) = makeSUT()
		service.getUserResult = .failure(NetworkError.connectivity)
		sut.searchText = "octocat"

		let spy = PublisherSpy(sut.$state)
		await sut.searchUser()

		XCTAssertEqual(spy.values, [.idle, .isLoading, .failure(.serverError)])
	}

	func test_searchUser_doesNotSearchWhenTextIsEmpty() async {
		let (sut, service) = makeSUT()
		sut.searchText = "   "

		await sut.searchUser()

		XCTAssertEqual(service.getUserCallCount, 0)
		XCTAssertEqual(sut.state, .idle)
	}

	func test_searchUser_trimsWhitespace() async {
		let (sut, service) = makeSUT()
		service.getUserResult = .success(makeUser())
		sut.searchText = "  octocat  "

		await sut.searchUser()

		XCTAssertEqual(service.getUserUsernames, ["octocat"])
	}

	// MARK: - Helpers

	private func makeSUT() -> (SearchUserViewModel, GitHubUserServiceSpy) {
		let service = GitHubUserServiceSpy()
		let sut = SearchUserViewModel(service: service)
		return (sut, service)
	}
}
