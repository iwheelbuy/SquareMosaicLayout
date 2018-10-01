import Foundation

public protocol SMLSupplementary {
    
    func smlSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect
    func smlSupplementaryKind() -> String
}
