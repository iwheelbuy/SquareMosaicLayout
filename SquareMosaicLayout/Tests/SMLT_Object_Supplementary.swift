import XCTest

@testable import SquareMosaicLayout

class SLMTObjectSupplementary: XCTestCase {

    func test_sml_object_supplementary_is_properly_updated() {
        let supplementary = SMLObjectSupplementary.random
        let origin = CGFloat.random
        XCTAssert(supplementary.updated(direction: SMLObjectDirection.vertical, origin: origin).frame.origin.y == supplementary.frame.origin.y + origin)
        XCTAssert(supplementary.updated(direction: SMLObjectDirection.horizontal, origin: origin).frame.origin.x == supplementary.frame.origin.x + origin)
    }
    
    func test_sml_object_supplementary_is_properly_initialized_with_simple_values() {
        let frame = CGRect.random
        let kind = String.random
        let zIndex = Int.random
        let supplementary = SMLObjectSupplementary(frame: frame, kind: kind, zIndex: zIndex)
        XCTAssert(frame == supplementary.frame)
        XCTAssert(kind == supplementary.kind)
        XCTAssert(zIndex == supplementary.zIndex)
    }
    
    func test_sml_object_supplementary_is_properly_initialized_with_direction_and_length() {
        let kind = String.random
        let length = CGFloat.random
        let zIndex = Int.random
        XCTAssert(SMLObjectSupplementary(direction: .horizontal, kind: kind, length: length, zIndex: zIndex).frame.width == length)
        XCTAssert(SMLObjectSupplementary(direction: .vertical, kind: kind, length: length, zIndex: zIndex).frame.height == length)
    }
    
    func test_sml_object_supplementary_is_properly_initialized_with_valid_sml_supplementary() {
        let initial = CGFloat.random
        var origin = initial
        let kind = String.random
        let zIndex = Int.random
        for direction in [SMLObjectDirection.horizontal, .vertical] {
            let supplementary = SMLObjectSupplementary(direction: direction, origin: &origin, supplementary: Supplementary(kind: kind, length: .random), zIndex: zIndex)!
            XCTAssert([supplementary.frame.origin.y + supplementary.frame.size.height, supplementary.frame.origin.x + supplementary.frame.size.width].contains(origin))
            XCTAssert(kind == supplementary.kind)
            XCTAssert(zIndex == supplementary.zIndex)
        }
    }
    
    func test_sml_object_supplementary_is_not_initialized_with_invalid_sml_supplementary() {
        var origin = CGFloat.random
        let supplementary = SMLObjectSupplementary(direction: .random, origin: &origin, supplementary: nil, zIndex: .random)
        XCTAssert(supplementary == nil)
    }
}

private struct Supplementary: SMLSupplementary {
    
    let kind: String
    let length: CGFloat
    
    static var random: Supplementary {
        return Supplementary(kind: .random, length: .random)
    }
    
    func smlSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect {
        return CGRect(x: .random, y: origin, width: aspect, height: length)
    }
    
    func smlSupplementaryKind() -> String {
        return kind
    }
//    let after: CGFloat
//    let before: CGFloat
//    let between: CGFloat
//    
//    func smlPatternBlocks() -> [SMLBlock] {
//        return []
//    }
//    
//    func smlPatternSpacing(position: SMLPosition) -> CGFloat {
//        switch position {
//        case .after:
//            return after
//        case .before:
//            return before
//        case .between:
//            return between
//        }
//    }
//    
//    static var random: Pattern {
//        return Pattern(after: .random, before: .random, between: .random)
//    }
}
