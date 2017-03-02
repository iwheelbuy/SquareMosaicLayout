//
//  SquareMosaicLayoutPatterns.swift
//

import SquareMosaicLayout

fileprivate let offsetDefault: CGFloat = 10.0

class SnakeSquareMosaicSupplementary: SquareMosaicSupplementary {
    
    func frame(origin: CGFloat, width: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: width, height: width / 4.0)
    }
}

class SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            OneTwoSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock(),
            TwoOneSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return 10.0
    }
}

class TripleSquareMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            ThreeLeftSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock(),
        ]
    }
}

public class OneTwoSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offsetDefault - offsetDefault) / 3.0
        let max = width - min - offsetDefault
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: max, height: max))
        frames.append(CGRect(x: max + offsetDefault, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + offsetDefault, y: origin + min + offsetDefault, width: min, height: min))
        return frames
    }
}

public class TwoOneSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offsetDefault - offsetDefault) / 3.0
        let max = width - min - offsetDefault
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: min, height: min))
        frames.append(CGRect(x: 0, y: origin + offsetDefault + min, width: min, height: min))
        frames.append(CGRect(x: min + offsetDefault, y: origin, width: max, height: max))
        return frames
    }
}

public class ThreeLeftSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offsetDefault - offsetDefault) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offsetDefault, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offsetDefault + min + offsetDefault, y: origin, width: min, height: min))
        return frames
    }
}

public class ThreeRightSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offsetDefault - offsetDefault) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: min + offsetDefault + min + offsetDefault, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offsetDefault, y: origin, width: min, height: min))
        frames.append(CGRect(x: 0, y: origin, width: min, height: min))
        return frames
    }
}
