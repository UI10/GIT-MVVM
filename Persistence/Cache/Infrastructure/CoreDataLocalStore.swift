import CoreData

public final class CoreDataLocalStore: LocalStore {
	private let container: NSPersistentContainer

	public init(storeURL: URL? = nil) {
		let modelName = "Store"
		guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd"),
		      let model = NSManagedObjectModel(contentsOf: modelURL) else {
			fatalError("Failed to load CoreData model '\(modelName)'")
		}

		container = NSPersistentContainer(name: modelName, managedObjectModel: model)

		if let storeURL {
			let description = NSPersistentStoreDescription(url: storeURL)
			container.persistentStoreDescriptions = [description]
		}

		container.loadPersistentStores { _, error in
			if let error {
				fatalError("Failed to load persistent stores: \(error)")
			}
		}

		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
	}

	public init(container: NSPersistentContainer) {
		self.container = container
		container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
	}

	public func read<T: LocalModelConvertable>(predicate: NSPredicate?) async throws -> T {
		let context = container.viewContext
		return try await context.perform {
			let request = NSFetchRequest<T.ManagedType>(entityName: T.entityName)
			request.predicate = predicate
			request.fetchLimit = 1
			guard let managed = try context.fetch(request).first else {
				throw PersistenceError.notFound
			}
			return T.fromManagedObject(managed)
		}
	}

	public func readAll<T: LocalModelConvertable>() async throws -> [T] {
		let context = container.viewContext
		return try await context.perform {
			let request = NSFetchRequest<T.ManagedType>(entityName: T.entityName)
			let results = try context.fetch(request)
			return results.map { T.fromManagedObject($0) }
		}
	}

	public func write<T: LocalModelConvertable>(_ object: T) async throws {
		let context = container.viewContext
		try await context.perform {
			// Remove existing entry with same predicate if needed
			_ = object.toManagedObject(in: context)
			try context.save()
		}
	}
}

public enum PersistenceError: Error, Equatable {
	case notFound
	case saveFailed
}
