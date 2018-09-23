import XCTest

@testable import SquareMosaicLayout

class SMLTObjectItem: XCTestCase {
    
    func test_sml_object_item_is_properly_updated() {
        let item = SMLObjectItem.random
        let origin = CGFloat.random
        XCTAssert(item.updated(direction: SMLObjectDirection.vertical, origin: origin).frame.origin.y == item.frame.origin.y + origin)
        XCTAssert(item.updated(direction: SMLObjectDirection.horizontal, origin: origin).frame.origin.x == item.frame.origin.x + origin)
    }
    
    func test_sml_object_items_are_properly_updated() {
        let items = [SMLObjectItem].random
        let origin = CGFloat.random
        for (index, item) in items.updated(direction: SMLObjectDirection.vertical, origin: origin).enumerated() {
            XCTAssert(item.frame.origin.y == items[index].frame.origin.y + origin)
        }
        for (index, item) in items.updated(direction: SMLObjectDirection.horizontal, origin: origin).enumerated() {
            XCTAssert(item.frame.origin.x == items[index].frame.origin.x + origin)
        }
    }
}
