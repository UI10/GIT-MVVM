import Foundation

public final class SearchUserViewModel: ObservableObject {
	public enum Error: Swift.Error, Equatable {
		case notFound
		case serverError
	}

	public enum State: Equatable {
		case idle
		case isLoading
		case failure(Error)
		case success(GitHubUser)
	}

	@Published public var state: State = .idle
	@Published public var searchText: String = ""

	private let service: GitHubUserService
	private var searchTask: Task<Void, Never>?

	public init(service: GitHubUserService) {
		self.service = service
	}

	@MainActor public func searchUser() async {
		searchTask?.cancel()

		let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }

		state = .isLoading

		let task = Task {
			do {
				let user = try await service.getUser(username: trimmed)
				guard !Task.isCancelled else { return }
				state = .success(user)
			} catch is CancellationError {
				return
			} catch let error as NetworkError where error == .notFound {
				guard !Task.isCancelled else { return }
				state = .failure(.notFound)
			} catch {
				guard !Task.isCancelled else { return }
				state = .failure(.serverError)
			}
		}
		searchTask = task
		await task.value
	}
}
