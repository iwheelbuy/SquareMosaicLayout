import CoreGraphics
import Foundation

public protocol SMLayoutSupplementary {
    
    func smLayoutSupplementaryFrame(aspect: SMLayoutAspect, origin: CGFloat) -> CGRect
    func smLayoutSupplementaryKind() -> String
    func smLayoutSupplementarySticky() -> Bool
}
