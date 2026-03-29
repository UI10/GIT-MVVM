import Foundation

public final class UserListViewModel: ObservableObject {
	public enum Error: Swift.Error, Equatable {
		case serverError
	}

	public enum State: Equatable {
		case idle
		case isLoading
		case failure(Error)
		case success([UserSummary])
	}

	@Published public var state: State = .idle

	private let username: String
	private let perPage: Int
	private let loader: (String, Int, Int) async throws -> [UserSummary]

	private var currentPage = 1
	private var hasMorePages = true
	private var allUsers: [UserSummary] = []

	public init(
		username: String,
		perPage: Int = 30,
		loader: @escaping (String, Int, Int) async throws -> [UserSummary]
	) {
		self.username = username
		self.perPage = perPage
		self.loader = loader
	}

	@MainActor public func loadFirstPage() async {
		currentPage = 1
		allUsers = []
		hasMorePages = true
		state = .isLoading

		await loadPage()
	}

	@MainActor public func refresh() async {
		await loadFirstPage()
	}

	@MainActor public func loadNextPageIfNeeded(currentItem: UserSummary) async {
		guard hasMorePages,
			  case .success(let users) = state,
			  users.last == currentItem else { return }

		await loadPage()
	}

	@MainActor private func loadPage() async {
		do {
			let newUsers = try await loader(username, currentPage, perPage)
			allUsers.append(contentsOf: newUsers)
			hasMorePages = newUsers.count == perPage
			currentPage += 1
			state = .success(allUsers)
		} catch {
			if allUsers.isEmpty {
				state = .failure(.serverError)
			}
		}
	}
}
