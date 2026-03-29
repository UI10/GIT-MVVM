import Foundation

public protocol GitHubUserCache {
	func save(user: GitHubUser) async throws
	func loadUser(username: String) async throws -> GitHubUser
}
