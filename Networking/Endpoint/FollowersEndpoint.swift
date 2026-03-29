import Foundation

public struct FollowersEndpoint: Endpoint {
	public let path: String
	public let method = RequestMethod.get
	public let queryItems: [URLQueryItem]

	public init(username: String, page: Int, perPage: Int) {
		self.path = "/users/\(username)/followers"
		self.queryItems = [
			URLQueryItem(name: "page", value: "\(page)"),
			URLQueryItem(name: "per_page", value: "\(perPage)")
		]
	}
}
