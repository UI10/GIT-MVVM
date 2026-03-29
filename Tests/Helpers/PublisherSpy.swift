import Combine

final class PublisherSpy<Value> {
	private(set) var values = [Value]()
	private var cancellable: AnyCancellable?

	init<P: Publisher>(_ publisher: P) where P.Output == Value, P.Failure == Never {
		cancellable = publisher.sink { [weak self] value in
			self?.values.append(value)
		}
	}
}
