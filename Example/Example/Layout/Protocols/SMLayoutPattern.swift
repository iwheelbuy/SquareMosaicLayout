import CoreGraphics
import Foundation

public protocol SMLayoutPattern {
    
    func smLayoutPatternBlocks() -> [SMLayoutBlock]
    func smLayoutPatternSpacing(previous: SMLayoutBlock, current: SMLayoutBlock) -> CGFloat
}
