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
    
    func smlSourcePattern(section: Int) -> SMLPattern
    func layoutSeparatorBetweenSections() -> CGFloat
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool
    func layoutSupplementaryFooter(for section: Int) -> SMLSupplementary?
    func layoutSupplementaryHeader(for section: Int) -> SMLSupplementary?
}

public extension SMLSource {
    
    func layoutSeparatorBetweenSections() -> CGFloat {
        return 0
    }
    
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool {
        return false
    }
    
    func layoutSupplementaryFooter(for section: Int) -> SMLSupplementary? {
        return nil
    }
    
    func layoutSupplementaryHeader(for section: Int) -> SMLSupplementary? {
        return nil
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
