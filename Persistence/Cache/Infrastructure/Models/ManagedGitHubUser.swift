import CoreData

@objc(ManagedGitHubUser)
public final class ManagedGitHubUser: NSManagedObject {
	@NSManaged public var id: Int64
	@NSManaged public var login: String
	@NSManaged public var avatarURL: String
	@NSManaged public var name: String?
	@NSManaged public var bio: String?
	@NSManaged public var followers: Int64
	@NSManaged public var following: Int64
	@NSManaged public var cachedAt: Date
}
