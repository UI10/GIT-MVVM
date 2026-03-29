import Foundation
@testable import GIT_MVVM

final class HTTPClientSpy: HTTPClient {
	private(set) var requests = [URLRequest]()
	private var results = [Result<(Data, HTTPURLResponse), Error>]()

	func stub(_ result: Result<(Data, HTTPURLResponse), Error>) {
		results.append(result)
	}

	func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		requests.append(request)
		let result = results.removeFirst()
		return try result.get()
	}
}
