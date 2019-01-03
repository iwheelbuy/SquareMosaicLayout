import XCTest

@testable import SquareMosaicLayout

class SMLTObjectSpacing: XCTestCase {
    
    func test_sml_object_spacing_is_not_initialized_when_current_or_total_has_unapropriate_value() {
        XCTAssert(SMLObjectSpacing(current: -1, pattern: Pattern.random, position: .random, total: .random) == nil)
        XCTAssert(SMLObjectSpacing(current: .random, pattern: Pattern.random, position: .random, total: -1) == nil)
        XCTAssert(SMLObjectSpacing(current: 1, pattern: Pattern.random, position: .random, total: 1) == nil)
        XCTAssert(SMLObjectSpacing(current: 2, pattern: Pattern.random, position: .random, total: 1) == nil)
    }
    
    func test_sml_object_spacing_is_initialized_for_after_position_and_only_last_index() {
        let total = 50
        let pattern = Pattern.random
        for current in 0 ..< total {
            let isLast = current + 1 == total
            let isEqual = SMLObjectSpacing(current: current, pattern: pattern, position: .after, total: total)?.value == pattern.smlPatternBlockSpacing(position: .after)
            XCTAssert((isLast && isEqual) || (!isLast && !isEqual))
        }
    }
    
    func test_sml_object_spacing_is_initialized_for_before_position_and_only_first_index() {
        let total = 50
        let pattern = Pattern.random
        for current in 0 ..< total {
            let isFirst = current == 0
            let isEqual = SMLObjectSpacing(current: current, pattern: pattern, position: .before, total: total)?.value == pattern.smlPatternBlockSpacing(position: .before)
            XCTAssert((isFirst && isEqual) || (!isFirst && !isEqual))
        }
    }
    
    func test_sml_object_spacing_is_initialized_for_between_position_and_any_but_first_index() {
        let total = 50
        let pattern = Pattern.random
        for current in 0 ..< total {
            let isNotFirst = current != 0
            let isEqual = SMLObjectSpacing(current: current, pattern: pattern, position: .between, total: total)?.value == pattern.smlPatternBlockSpacing(position: .between)
            XCTAssert((isNotFirst && isEqual) || (!isNotFirst && !isEqual))
        }
    }
}

private struct Pattern: SMLPattern {
    
    let after: CGFloat
    let before: CGFloat
    let between: CGFloat
    
    func smlPatternBlocks() -> [SMLBlock] {
        return []
    }
    
    func smlPatternSpacing(previous: SMLBlock, current: SMLBlock) -> CGFloat {
        return 0
    }

//    func smlPatternBlockSpacing(position: SMLPosition) -> CGFloat {
//        switch position {
//        case .after:
//            return after
//        case .before:
//            return before
//        case .between:
//            return between
//        }
//    }
    
    static var random: Pattern {
        return Pattern(after: .random, before: .random, between: .random)
    }
}
