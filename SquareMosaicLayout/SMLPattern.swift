import Foundation

public protocol SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock]
    func smlPatternSpacing(position: SMLPosition) -> CGFloat
}

public extension SMLPattern {
    
    func smlPatternSpacing(position: SMLPosition) -> CGFloat {
        return 0
    }
}
