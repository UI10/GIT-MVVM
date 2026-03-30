import SwiftUI

@main
struct GitHubExplorerApp: App {
	private let factory = AppFactory()
	@State private var showLaunch = true

	var body: some Scene {
		WindowGroup {
			ZStack {
				SearchFlowView(factory: factory)
					.opacity(showLaunch ? 0 : 1)

				if showLaunch {
					LaunchScreenView()
						.transition(.opacity)
				}
			}
			.preferredColorScheme(.dark)
			.task {
				try? await Task.sleep(for: .seconds(2.2))
				withAnimation(.easeOut(duration: 0.5)) {
					showLaunch = false
				}
			}
		}
	}
}
