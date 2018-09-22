import Foundation

// MARK: -

public protocol SMLBlock {
    ///
    func smlBlockCapacity() -> Int
    ///
    func smlBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect]
    ///
    func smlBlockRepeated() -> Bool
}

public extension SMLBlock {
    
    func smlBlockRepeated() -> Bool {
        return false
    }
}

// MARK: - SMLPosition

public enum SMLPosition: Int {
    
    case after, before, between
}

// MARK: - SMLSource

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

// MARK: - SMLDelegate

public protocol SMLDelegate: class {
    
    func layoutContentSizeChanged(to size: CGSize) -> Void
}

// MARK: - SMLPattern

public protocol SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock]
    func smlPatternSpacing(position: SMLPosition) -> CGFloat
}

public extension SMLPattern {
    
    func smlPatternSpacing(position: SMLPosition) -> CGFloat {
        return 0
    }
}

// MARK: - SMLSupplementary

public protocol SMLSupplementary {
    
    func smlSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect
    func smlSupplementaryIsHiddenForEmptySection() -> Bool
}

public extension SMLSupplementary {
    
    func smlSupplementaryIsHiddenForEmptySection() -> Bool {
        return false
    }
}
