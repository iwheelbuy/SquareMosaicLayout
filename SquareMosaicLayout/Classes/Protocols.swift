import Foundation

public protocol SquareMosaicBlock {
    
    func frames() -> Int
    func frames(origin: CGFloat, width: CGFloat) -> [CGRect]
}

public protocol SquareMosaicSupplementary {
    
    func frame(origin: CGFloat, width: CGFloat) -> CGRect
}

public protocol SquareMosaicPattern {
    
    var blocks: [SquareMosaicBlock] { get }
}

public protocol SquareMosaicDelegate: class {
    
    func layoutHeight(_ height: CGFloat) -> Void
}

public protocol SquareMosaicDataSource: class {
    
    func footer(section: Int) -> SquareMosaicSupplementary?
    func header(section: Int) -> SquareMosaicSupplementary?
    func pattern(section: Int) -> SquareMosaicPattern
}
