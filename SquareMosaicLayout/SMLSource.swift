import Foundation

public protocol SMLSource: class {
    
    func smlSourceBacker(section: Int) -> Bool
    func smlSourceFooter(section: Int) -> SMLSupplementary?
    func smlSourceHeader(section: Int) -> SMLSupplementary?
    func smlSourcePattern(section: Int) -> SMLPattern
    func smlSourceSpacing() -> CGFloat
}

public extension SMLSource {
    
    func smlSourceBacker(section: Int) -> Bool {
        return false
    }
    
    func smlSourceFooter(section: Int) -> SMLSupplementary? {
        return nil
    }
    
    func smlSourceHeader(section: Int) -> SMLSupplementary? {
        return nil
    }
    
    func smlSourceSpacing() -> CGFloat {
        return 0
    }
}
