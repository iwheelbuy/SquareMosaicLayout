import Foundation

public protocol SquareMosaicBlock {
    
    func blockFrames() -> Int
    func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect]
}

public enum SquareMosaicBlockSeparatorPosition: Int {
    
    case beforeBlocks, afterBlocks, betweenBlocks
}

public protocol SquareMosaicDataSource: class {
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern
    func layoutSeparatorBetweenSections() -> CGFloat
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool
    func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary?
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary?
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

public protocol SquareMosaicSupplementary {
    
    func supplementaryFrame(for origin: CGFloat, side: CGFloat) -> CGRect
    func supplementaryHiddenForEmptySection() -> Bool
}
