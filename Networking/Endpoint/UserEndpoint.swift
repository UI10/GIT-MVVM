import Foundation

public struct UserEndpoint: Endpoint {
	public let path: String
	public let method = RequestMethod.get

	public init(username: String) {
		self.path = "/users/\(username)"
	}
}
