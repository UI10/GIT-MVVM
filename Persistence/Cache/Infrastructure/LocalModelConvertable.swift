import CoreData

public protocol LocalModelConvertable {
	associatedtype ManagedType: NSManagedObject

	static var entityName: String { get }
	func toManagedObject(in context: NSManagedObjectContext) -> ManagedType
	static func fromManagedObject(_ managed: ManagedType) -> Self
}
