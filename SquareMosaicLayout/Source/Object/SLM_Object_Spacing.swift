import Foundation

struct SMLObjectSpacing {
    
    let value: CGFloat
    
    init?(current: Int, pattern: SMLPattern, position: SMLPosition, total: Int) {
        if current < 0 || total < 0 || current >= total {
            return nil
        }
        let first = current == 0
        let last = current + 1 == total
        switch (position, first, last) {
        case (.after, _, true):
            self.value = pattern.smlPatternSpacing(position: .after)
        case (.before, true, _):
            self.value = pattern.smlPatternSpacing(position: .before)
        case (.between, false, _):
            self.value = pattern.smlPatternSpacing(position: .between)
        default:
            return nil
        }
    }
}
