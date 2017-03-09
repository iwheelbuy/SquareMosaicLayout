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
    
    func background(section: Int) -> Bool
    func footer(section: Int) -> SquareMosaicSupplementary?
    func header(section: Int) -> SquareMosaicSupplementary?
    func pattern(section: Int) -> SquareMosaicPattern
    func separator() -> CGFloat
}

public protocol SquareMosaicDelegate: class {
    
    func layoutSize(_ size: CGSize) -> Void
}
