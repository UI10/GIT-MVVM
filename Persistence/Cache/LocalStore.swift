import Foundation

public protocol LocalStore {
	func read<T: LocalModelConvertable>(predicate: NSPredicate?) async throws -> T
	func readAll<T: LocalModelConvertable>() async throws -> [T]
	func write<T: LocalModelConvertable>(_ object: T) async throws
}
