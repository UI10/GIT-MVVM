import Foundation

struct RemoteUserSummary: Decodable {
	let id: Int
	let login: String
	let avatar_url: URL

	var toModel: UserSummary {
		UserSummary(
			id: id,
			login: login,
			avatarURL: avatar_url
		)
	}
}
