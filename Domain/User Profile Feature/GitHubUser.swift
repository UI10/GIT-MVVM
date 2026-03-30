import Foundation

public struct GitHubUser: Hashable {
	public let id: Int
	public let login: String
	public let avatarURL: URL
	public let name: String?
	public let bio: String?
	public let followers: Int
	public let following: Int

	public init(id: Int, login: String, avatarURL: URL, name: String?, bio: String?, followers: Int, following: Int) {
		self.id = id
		self.login = login
		self.avatarURL = avatarURL
		self.name = name
		self.bio = bio
		self.followers = followers
		self.following = following
	}
}
