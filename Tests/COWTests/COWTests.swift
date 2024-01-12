import XCTest
@testable import COW

final class COWTests: XCTestCase {
	private final class MutableClass {
		var text: String
		
		init(text: String) {
			self.text = text
		}
	}
	
	private var sut: COW<MutableClass>!
	
	override func setUp() {
		self.sut = COW(MutableClass(text: "foo"), copyFunction: { MutableClass(text: $0.text) })
	}
	
	func testReadonly() {
		let mcBefore = self.sut.object
		_ = self.sut.readOnlyObject
		let mcAfter = self.sut.object
		
		XCTAssertIdentical(mcBefore, mcAfter)
	}
	
	func testMutating_withoutChange() {
		let mcBefore = self.sut.object // This creates another strong reference, requiring a copy
		_ = self.sut.mutableObject
		let mcAfter = self.sut.object
		
		XCTAssertNotIdentical(mcBefore, mcAfter)
		XCTAssertEqual(mcBefore.text, mcAfter.text) // They still have the same text, though
	}
	
	func testMutating_withChange() {
		let mcBefore = self.sut.object // This creates another strong reference, requiring a copy
		self.sut.mutableObject.text.append("d is tasty")
		let mcAfter = self.sut.object
		
		XCTAssertNotIdentical(mcBefore, mcAfter)
		XCTAssertNotEqual(mcBefore.text, mcAfter.text)
		XCTAssertEqual(mcAfter.text, "food is tasty")
	}
}
