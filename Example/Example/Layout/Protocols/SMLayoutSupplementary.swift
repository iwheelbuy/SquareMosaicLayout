import CoreGraphics
import Foundation

public protocol SMLayoutSupplementary {
    
    func smLayoutSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect
    func smLayoutSupplementaryKind() -> String
    func smLayoutSupplementarySticky() -> Bool
}
