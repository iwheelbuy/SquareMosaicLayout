import CoreGraphics
import Foundation

struct SMLayoutBlockWrapper: SMLayoutBlock {
    
    private let capacity: () -> Int
    private let frames: (CGFloat, CGFloat) -> [CGRect]
    private let repeated: () -> Bool
    
    init(_ block: SMLayoutBlock) {
        capacity = block.smLayoutBlockCapacity
        frames = block.smLayoutBlockFrames
        repeated = block.smLayoutBlockRepeated
    }
    
    func smLayoutBlockCapacity() -> Int {
        return capacity()
    }
    
    func smLayoutBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        return frames(aspect, origin)
    }
    
    func smLayoutBlockRepeated() -> Bool {
        return repeated()
    }
}
