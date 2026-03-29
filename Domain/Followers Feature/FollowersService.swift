import Foundation

public protocol FollowersService {
	func getFollowers(username: String, page: Int, perPage: Int) async throws -> [UserSummary]
}
