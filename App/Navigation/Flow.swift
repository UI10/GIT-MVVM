import Foundation

final class Flow<Route: Hashable>: ObservableObject {
	@Published var path = [Route]()

	func append(_ value: Route) {
		path.append(value)
	}

	func navigateBack() {
		guard !path.isEmpty else { return }
		path.removeLast()
	}
}
