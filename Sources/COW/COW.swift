public struct COW<T: AnyObject> {
	private(set) var object: T
	private let copyFunction: (T) -> T

	public var readOnlyObject: T { self.object }
	public var mutableObject: T {
		mutating get {
			if !isKnownUniquelyReferenced(&self.object) {
				self.object = self.copyFunction(self.object)
			}

			return self.object
		}
	}

	public init(_ object: T, copyFunction: @escaping (T) -> T) {
		self.object = object
		self.copyFunction = copyFunction
	}
}

#if canImport(Foundation)

import Foundation

public extension COW where T: NSCopying {
	init(_ object: T) {
		self.object = object
		self.copyFunction = { $0.copy() as! T }
	}
}

#endif
