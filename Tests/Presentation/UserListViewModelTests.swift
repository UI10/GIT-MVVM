import XCTest
@testable import GIT_MVVM

@MainActor
final class UserListViewModelTests: XCTestCase {
	func test_init_startsInIdleState() {
		let sut = makeSUT()

		XCTAssertEqual(sut.state, .idle)
	}

	func test_loadFirstPage_setsLoadingThenSuccess() async {
		let users = [makeUserSummary(id: 1, login: "user1"), makeUserSummary(id: 2, login: "user2")]
		let sut = makeSUT(result: .success(users))

		let spy = PublisherSpy(sut.$state)
		await sut.loadFirstPage()

		XCTAssertEqual(spy.values, [.idle, .isLoading, .success(users)])
	}

	func test_loadFirstPage_setsFailureOnError() async {
		let sut = makeSUT(result: .failure(NetworkError.connectivity))

		await sut.loadFirstPage()

		XCTAssertEqual(sut.state, .failure(.serverError))
	}

	func test_loadNextPage_appendsUsers() async {
		let firstPage = [makeUserSummary(id: 1, login: "user1")]
		let secondPage = [makeUserSummary(id: 2, login: "user2")]
		var callCount = 0
		let sut = UserListViewModel(username: "octocat", perPage: 1) { _, _, _ in
			callCount += 1
			return callCount == 1 ? firstPage : secondPage
		}

		await sut.loadFirstPage()
		await sut.loadNextPageIfNeeded(currentItem: firstPage.last!)

		if case .success(let users) = sut.state {
			XCTAssertEqual(users.count, 2)
			XCTAssertEqual(users.map(\.login), ["user1", "user2"])
		} else {
			XCTFail("Expected success state")
		}
	}

	func test_refresh_resetsToFirstPage() async {
		let users = [makeUserSummary(id: 1, login: "user1")]
		let sut = makeSUT(result: .success(users))

		await sut.loadFirstPage()
		await sut.refresh()

		if case .success(let result) = sut.state {
			XCTAssertEqual(result.count, 1)
		} else {
			XCTFail("Expected success state")
		}
	}

	// MARK: - Helpers

	private func makeSUT(
		result: Result<[UserSummary], Error> = .success([])
	) -> UserListViewModel {
		UserListViewModel(username: "octocat") { _, _, _ in
			try result.get()
		}
	}
}
