import Foundation

public protocol GitHubUserService {
	func getUser(username: String) async throws -> GitHubUser
}
