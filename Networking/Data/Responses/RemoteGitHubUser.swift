import Foundation

struct RemoteGitHubUser: Decodable {
	let id: Int
	let login: String
	let avatar_url: URL
	let name: String?
	let bio: String?
	let followers: Int
	let following: Int

	var toModel: GitHubUser {
		GitHubUser(
			id: id,
			login: login,
			avatarURL: avatar_url,
			name: name,
			bio: bio,
			followers: followers,
			following: following
		)
	}
}
