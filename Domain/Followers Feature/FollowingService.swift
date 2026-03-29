import Foundation

public protocol FollowingService {
	func getFollowing(username: String, page: Int, perPage: Int) async throws -> [UserSummary]
}
