import Foundation

enum SearchRoute: Hashable {
	case profile(GitHubUser)
	case profileByUsername(String)
	case followers(String)
	case following(String)
}
