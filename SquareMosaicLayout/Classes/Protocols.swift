import Foundation

@objc public protocol SquareMosaicBlock {
    
    func frames() -> Int
    func frames(origin: CGFloat, side: CGFloat) -> [CGRect]
}

@objc public enum SquareMosaicDirection: Int {
    case horizontal, vertical
}

@objc public protocol SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock]
    @objc optional func separator(_ type: SquareMosaicSeparatorType) -> CGFloat
}

@objc public enum SquareMosaicSeparatorType: Int {
    case top, bottom, middle
}

@objc public protocol SquareMosaicSupplementary {
    
    func frame(origin: CGFloat, side: CGFloat) -> CGRect
}

@objc public protocol SquareMosaicDataSource: class {
    
    @objc optional func background(section: Int) -> Bool
    @objc optional func footer(section: Int) -> SquareMosaicSupplementary?
    @objc optional func header(section: Int) -> SquareMosaicSupplementary?
    @objc func pattern(section: Int) -> SquareMosaicPattern
    @objc optional func separator(_ type: SquareMosaicSeparatorType) -> CGFloat
}

@objc public protocol SquareMosaicDelegate: class {
    
    @objc optional func layoutSize(_ size: CGSize) -> Void
}
