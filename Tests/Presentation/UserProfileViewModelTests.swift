import XCTest
@testable import GIT_MVVM

@MainActor
final class UserProfileViewModelTests: XCTestCase {
	func test_init_startsInIdleState() {
		let sut = makeSUT(input: .username("octocat"))

		XCTAssertEqual(sut.state, .idle)
	}

	func test_loadProfile_setsSuccessImmediatelyWhenPreloaded() async {
		let user = makeUser()
		let sut = makeSUT(input: .preloaded(user))

		await sut.loadProfile()

		XCTAssertEqual(sut.state, .success(user))
	}

	func test_loadProfile_setsLoadingThenSuccess() async {
		let service = GitHubUserServiceSpy()
		let user = makeUser()
		service.getUserResult = .success(user)
		let sut = makeSUT(input: .username("octocat"), service: service)

		let spy = PublisherSpy(sut.$state)
		await sut.loadProfile()

		XCTAssertEqual(spy.values, [.idle, .isLoading, .success(user)])
	}

	func test_loadProfile_setsLoadingThenFailureOnError() async {
		let service = GitHubUserServiceSpy()
		service.getUserResult = .failure(NetworkError.connectivity)
		let sut = makeSUT(input: .username("octocat"), service: service)

		let spy = PublisherSpy(sut.$state)
		await sut.loadProfile()

		XCTAssertEqual(spy.values, [.idle, .isLoading, .failure(.serverError)])
	}

	func test_loadProfile_doesNothingWhenPreloaded() async {
		let service = GitHubUserServiceSpy()
		let user = makeUser()
		let sut = makeSUT(input: .preloaded(user), service: service)

		await sut.loadProfile()

		XCTAssertEqual(service.getUserCallCount, 0)
	}

	// MARK: - Helpers

	private func makeSUT(
		input: UserProfileViewModel.Input = .username("octocat"),
		service: GitHubUserServiceSpy = GitHubUserServiceSpy()
	) -> UserProfileViewModel {
		UserProfileViewModel(input: input, service: service)
	}
}
