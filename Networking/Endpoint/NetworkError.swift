import Foundation

public enum NetworkError: Error, Equatable {
	case invalidURL
	case connectivity
	case invalidData
	case notFound
}
