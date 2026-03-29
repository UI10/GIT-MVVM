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

	public init(service: GitHubUserService) {
		self.service = service
	}

	@MainActor public func searchUser() async {
		let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
		guard !trimmed.isEmpty else { return }

		state = .isLoading
		do {
			let user = try await service.getUser(username: trimmed)
			state = .success(user)
		} catch let error as NetworkError where error == .notFound {
			state = .failure(.notFound)
		} catch {
			state = .failure(.serverError)
		}
	}
}
