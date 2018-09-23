import XCTest

@testable import SquareMosaicLayout

class SLMTObjectSection: XCTestCase {
    
    func test_sml_object_section_is_properly_updated() {
        let section = SMLObjectSection.random
        for direction in [SMLObjectDirection.horizontal, .vertical] {
            let initial = CGFloat.random
            var origin = initial
            XCTAssert(section.updated(direction: direction, origin: &origin).origin == section.origin + initial)
        }
    }
    
    func test_sml_object_section_is_properly_initialized() {
        let backer = SMLObjectSupplementary.random
        let footer = SMLObjectSupplementary.random
        let header = SMLObjectSupplementary.random
        let index = Int.random
        let items = [SMLObjectItem].random
        let length = CGFloat.random
        let origin = CGFloat.random
        let section = SMLObjectSection(backer: backer, footer: footer, header: header, index: index, items: items, length: length, origin: origin)
        XCTAssert(backer == section.backer)
        XCTAssert(footer == section.footer)
        XCTAssert(header == section.header)
        XCTAssert(index == section.index)
        XCTAssert(items == section.items)
        XCTAssert(length == section.length)
        XCTAssert(origin == section.origin)
    }
}
