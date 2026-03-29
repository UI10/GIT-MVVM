import Foundation

public final class RemoteStore {
	private let client: HTTPClient

	public init(client: HTTPClient) {
		self.client = client
	}

	func get<T: Decodable>(for endpoint: Endpoint) async throws -> T {
		let request = try endpoint.createURLRequest()

		let (data, response): (Data, HTTPURLResponse)
		do {
			(data, response) = try await client.send(request)
		} catch {
			throw NetworkError.connectivity
		}

		guard response.statusCode != 404 else {
			throw NetworkError.notFound
		}

		guard (200...299).contains(response.statusCode) else {
			throw NetworkError.invalidData
		}

		do {
			return try JSONDecoder().decode(T.self, from: data)
		} catch {
			throw NetworkError.invalidData
		}
	}
}
