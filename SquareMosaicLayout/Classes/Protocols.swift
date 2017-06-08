import Foundation

@objc public protocol SquareMosaicBlock {
    
    func blockFrames() -> Int
    func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect]
}

@objc public enum SquareMosaicBlockSeparatorPosition: Int {
    
    case after, before, between
}

@objc public protocol SquareMosaicDataSource: class {
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern
    @objc optional func layoutSeparatorBetweenSections() -> CGFloat
    @objc optional func layoutSupplementaryBackerRequired(for section: Int) -> Bool
    @objc optional func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary?
    @objc optional func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary?
}

public protocol SquareMosaicDelegate: class {
    
    func layoutContentSizeChanged(to size: CGSize) -> Void
}

public enum SquareMosaicDirection: Int {
    
    case horizontal, vertical
}

@objc public protocol SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock]
    @objc optional func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat
}

@objc public protocol SquareMosaicSupplementary {
    
    func supplementaryFrame(for origin: CGFloat, side: CGFloat) -> CGRect
    @objc optional func supplementaryHiddenForEmptySection() -> Bool
}
