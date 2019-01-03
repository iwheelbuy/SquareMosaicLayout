import CoreGraphics
import Foundation

public protocol SMLayoutBlock {
    ///
    func smLayoutBlockCapacity() -> Int
    ///
    func smLayoutBlockFrames(aspect: SMLayoutAspect, origin: CGFloat) -> [CGRect]
    ///
    func smLayoutBlockRepeated() -> Bool
}
