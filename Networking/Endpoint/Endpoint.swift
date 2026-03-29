import Foundation

public protocol Endpoint {
	var path: String { get }
	var method: RequestMethod { get }
	var queryItems: [URLQueryItem] { get }
}

extension Endpoint {
	public var queryItems: [URLQueryItem] { [] }

	public func createURLRequest() throws -> URLRequest {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "api.github.com"
		components.path = path

		if !queryItems.isEmpty {
			components.queryItems = queryItems
		}

		guard let url = components.url else {
			throw NetworkError.invalidURL
		}

		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
		return request
	}
}
