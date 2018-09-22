import Foundation

public protocol SMLSupplementary {
    
    func smlSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect
    func smlSupplementaryIsHiddenForEmptySection() -> Bool
}

public extension SMLSupplementary {
    
    func smlSupplementaryIsHiddenForEmptySection() -> Bool {
        return false
    }
}
