import Foundation
@testable import GIT_MVVM

func makeUser(
	id: Int = 1,
	login: String = "octocat",
	avatarURL: URL = URL(string: "https://avatars.githubusercontent.com/u/1")!,
	name: String? = "The Octocat",
	bio: String? = "A GitHub mascot",
	followers: Int = 100,
	following: Int = 50
) -> GitHubUser {
	GitHubUser(
		id: id,
		login: login,
		avatarURL: avatarURL,
		name: name,
		bio: bio,
		followers: followers,
		following: following
	)
}

func makeUserSummary(
	id: Int = 1,
	login: String = "octocat",
	avatarURL: URL = URL(string: "https://avatars.githubusercontent.com/u/1")!
) -> UserSummary {
	UserSummary(id: id, login: login, avatarURL: avatarURL)
}

func makeUserJSON(
	id: Int = 1,
	login: String = "octocat",
	avatarURL: String = "https://avatars.githubusercontent.com/u/1",
	name: String? = "The Octocat",
	bio: String? = "A GitHub mascot",
	followers: Int = 100,
	following: Int = 50
) -> Data {
	var dict: [String: Any] = [
		"id": id,
		"login": login,
		"avatar_url": avatarURL,
		"followers": followers,
		"following": following
	]
	if let name { dict["name"] = name }
	if let bio { dict["bio"] = bio }
	return try! JSONSerialization.data(withJSONObject: dict)
}

func makeUserSummaryArrayJSON(count: Int = 2) -> Data {
	let items = (0..<count).map { i in
		[
			"id": i + 1,
			"login": "user\(i + 1)",
			"avatar_url": "https://avatars.githubusercontent.com/u/\(i + 1)"
		] as [String: Any]
	}
	return try! JSONSerialization.data(withJSONObject: items)
}

func makeHTTPResponse(statusCode: Int = 200) -> HTTPURLResponse {
	HTTPURLResponse(
		url: URL(string: "https://api.github.com")!,
		statusCode: statusCode,
		httpVersion: nil,
		headerFields: nil
	)!
}
