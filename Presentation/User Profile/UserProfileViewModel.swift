import Foundation

public final class UserProfileViewModel: ObservableObject {
	public enum Input {
		case preloaded(GitHubUser)
		case username(String)
	}

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

	private let input: Input
	private let service: GitHubUserService

	public init(input: Input, service: GitHubUserService) {
		self.input = input
		self.service = service
	}

	@MainActor public func loadProfile() async {
		switch input {
		case .preloaded(let user):
			state = .success(user)

		case .username(let username):
			state = .isLoading
			do {
				let user = try await service.getUser(username: username)
				state = .success(user)
			} catch let error as NetworkError where error == .notFound {
				state = .failure(.notFound)
			} catch {
				state = .failure(.serverError)
			}
		}
	}
}
