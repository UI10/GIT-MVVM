import Foundation

public final class URLSessionHTTPClient: HTTPClient {
	private let session: URLSession

	public init(session: URLSession = .shared) {
		self.session = session
	}

	public func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		let (data, response) = try await session.data(for: request)

		guard let httpResponse = response as? HTTPURLResponse else {
			throw NetworkError.connectivity
		}

		return (data, httpResponse)
	}
}
