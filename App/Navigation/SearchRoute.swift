import Foundation

enum SearchRoute: Hashable {
	case profile(String)
	case followers(String)
	case following(String)
}
