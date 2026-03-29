import Foundation

final class GitHubUserServiceWithFallbackComposite: GitHubUserService {
	private let primary: GitHubUserService
	private let secondary: GitHubUserService

	init(primary: GitHubUserService, secondary: GitHubUserService) {
		self.primary = primary
		self.secondary = secondary
	}

	func getUser(username: String) async throws -> GitHubUser {
		do {
			return try await primary.getUser(username: username)
		} catch {
			return try await secondary.getUser(username: username)
		}
	}
}
