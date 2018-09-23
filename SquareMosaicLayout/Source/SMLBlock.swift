import Foundation

public protocol SMLBlock {
    ///
    func smlBlockCapacity() -> Int
    ///
    func smlBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect]
    ///
    func smlBlockRepeated() -> Bool
}
