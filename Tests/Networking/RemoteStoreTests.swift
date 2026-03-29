import XCTest
@testable import GIT_MVVM

final class RemoteStoreTests: XCTestCase {
	func test_get_sendsRequestToClient() async throws {
		let (sut, client) = makeSUT()
		let endpoint = UserEndpoint(username: "octocat")
		client.stub(.success((makeUserJSON(), makeHTTPResponse())))

		let _: RemoteGitHubUser = try await sut.get(for: endpoint)

		XCTAssertEqual(client.requests.count, 1)
		XCTAssertEqual(client.requests.first?.url?.path, "/users/octocat")
	}

	func test_get_throwsConnectivityOnClientError() async {
		let (sut, client) = makeSUT()
		let endpoint = UserEndpoint(username: "octocat")
		client.stub(.failure(NSError(domain: "test", code: 0)))

		do {
			let _: RemoteGitHubUser = try await sut.get(for: endpoint)
			XCTFail("Expected error")
		} catch {
			XCTAssertEqual(error as? NetworkError, .connectivity)
		}
	}

	func test_get_throwsNotFoundOn404() async {
		let (sut, client) = makeSUT()
		let endpoint = UserEndpoint(username: "nonexistent")
		client.stub(.success((Data(), makeHTTPResponse(statusCode: 404))))

		do {
			let _: RemoteGitHubUser = try await sut.get(for: endpoint)
			XCTFail("Expected error")
		} catch {
			XCTAssertEqual(error as? NetworkError, .notFound)
		}
	}

	func test_get_throwsInvalidDataOnNon2xx() async {
		let (sut, client) = makeSUT()
		let endpoint = UserEndpoint(username: "octocat")
		client.stub(.success((Data(), makeHTTPResponse(statusCode: 500))))

		do {
			let _: RemoteGitHubUser = try await sut.get(for: endpoint)
			XCTFail("Expected error")
		} catch {
			XCTAssertEqual(error as? NetworkError, .invalidData)
		}
	}

	func test_get_throwsInvalidDataOnInvalidJSON() async {
		let (sut, client) = makeSUT()
		let endpoint = UserEndpoint(username: "octocat")
		client.stub(.success((Data("invalid".utf8), makeHTTPResponse())))

		do {
			let _: RemoteGitHubUser = try await sut.get(for: endpoint)
			XCTFail("Expected error")
		} catch {
			XCTAssertEqual(error as? NetworkError, .invalidData)
		}
	}

	// MARK: - Helpers

	private func makeSUT() -> (RemoteStore, HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteStore(client: client)
		return (sut, client)
	}
}
