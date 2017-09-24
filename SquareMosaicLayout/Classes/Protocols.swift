import Foundation

public protocol SquareMosaicBlock {
    
    func blockFrames() -> Int
    func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect]
}

public enum SquareMosaicBlockSeparatorPosition: Int {
    
    case after, before, between
}

public protocol SquareMosaicDataSource: class {
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern
    func layoutSeparatorBetweenSections() -> CGFloat
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool
    func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary?
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary?
}

public extension SquareMosaicDataSource {
    
    func layoutSeparatorBetweenSections() -> CGFloat {
        return 0
    }
    
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool {
        return false
    }
    
    func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary? {
        return nil
    }
    
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary? {
        return nil
    }
}

public protocol SquareMosaicDelegate: class {
    
    func layoutContentSizeChanged(to size: CGSize) -> Void
}

public enum SquareMosaicDirection: Int {
    
    case horizontal, vertical
}

public protocol SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock]
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat
}

public extension SquareMosaicPattern {
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return 0
    }
}

public protocol SquareMosaicSupplementary {
    
    func supplementaryFrame(for origin: CGFloat, side: CGFloat) -> CGRect
    func supplementaryHiddenForEmptySection() -> Bool
}

public extension SquareMosaicSupplementary {
    
    func supplementaryHiddenForEmptySection() -> Bool {
        return true
    }
}
