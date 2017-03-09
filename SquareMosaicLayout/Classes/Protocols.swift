import Foundation

public protocol SquareMosaicBlock {
    
    func frames() -> Int
    func frames(origin: CGFloat, side: CGFloat) -> [CGRect]
}

public enum SquareMosaicDirection: Int {
    case horizontal, vertical
}

public protocol SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock]
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat
}

public enum SquareMosaicSeparatorType: Int {
    case top, bottom, middle
}

public protocol SquareMosaicSupplementary {
    
    func dynamic() -> Bool
    func frame(origin: CGFloat, side: CGFloat) -> CGRect
}

public protocol SquareMosaicDataSource: class {
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern
    func layoutSeparatorBetweenSections() -> CGFloat
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool
    func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary?
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary?
}

public protocol SquareMosaicDelegate: class {
    
    func layoutContentSizeChanged(_ size: CGSize) -> Void
}
