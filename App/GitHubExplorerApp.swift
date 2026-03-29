import SwiftUI

@main
struct GitHubExplorerApp: App {
	private let factory = AppFactory()

	var body: some Scene {
		WindowGroup {
			SearchFlowView(factory: factory)
		}
	}
}
