import Foundation

public protocol SMLSource: class {
    
    func smlSourceBacker(section: Int) -> String?
    func smlSourceFooter(section: Int) -> SMLSupplementary?
    func smlSourceHeader(section: Int) -> SMLSupplementary?
    func smlSourcePattern(section: Int) -> SMLPattern
    func smlSourceSpacing() -> CGFloat
}

public extension SMLSource {
    
    func smlSourceBacker(section: Int) -> String? {
        return nil
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
