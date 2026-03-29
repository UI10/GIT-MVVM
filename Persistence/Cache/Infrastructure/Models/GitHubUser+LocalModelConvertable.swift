import CoreData

extension GitHubUser: LocalModelConvertable {
	public static var entityName: String { "ManagedGitHubUser" }

	public func toManagedObject(in context: NSManagedObjectContext) -> ManagedGitHubUser {
		let managed = ManagedGitHubUser(context: context)
		managed.id = Int64(id)
		managed.login = login
		managed.avatarURL = avatarURL.absoluteString
		managed.name = name
		managed.bio = bio
		managed.followers = Int64(followers)
		managed.following = Int64(following)
		managed.cachedAt = Date()
		return managed
	}

	public static func fromManagedObject(_ managed: ManagedGitHubUser) -> GitHubUser {
		GitHubUser(
			id: Int(managed.id),
			login: managed.login,
			avatarURL: URL(string: managed.avatarURL)!,
			name: managed.name,
			bio: managed.bio,
			followers: Int(managed.followers),
			following: Int(managed.following)
		)
	}
}
