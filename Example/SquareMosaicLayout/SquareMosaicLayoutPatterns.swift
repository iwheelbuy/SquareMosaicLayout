//
//  SquareMosaicLayoutPatterns.swift
//

import SquareMosaicLayout

struct SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    var blocks: [SquareMosaicBlock] {
        return [
            OneTwoSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock(),
            TwoOneSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock()
        ]
    }
}

struct TripleSquareMosaicPattern: SquareMosaicPattern {
    
    var blocks: [SquareMosaicBlock] {
        return [
            ThreeLeftSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock(),
        ]
    }
}

public struct OneTwoSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let sideMin = width / 3.0
        let sideMax = width - sideMin
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: sideMax, height: sideMax))
        frames.append(CGRect(x: sideMax, y: origin, width: sideMin, height: sideMin))
        frames.append(CGRect(x: sideMax, y: origin + sideMax - sideMin, width: sideMin, height: sideMin))
        return frames
    }
}

public struct TwoOneSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let sideMin = width / 3.0
        let sideMax = width - sideMin
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: sideMin, height: sideMin))
        frames.append(CGRect(x: 0, y: origin + sideMax - sideMin, width: sideMin, height: sideMin))
        frames.append(CGRect(x: sideMin, y: origin, width: sideMax, height: sideMax))
        return frames
    }
}

public struct ThreeLeftSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let side = width / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: side, height: side))
        frames.append(CGRect(x: side, y: origin, width: side, height: side))
        frames.append(CGRect(x: side + side, y: origin, width: side, height: side))
        return frames
    }
}

public struct ThreeRightSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let side = width / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: side + side, y: origin, width: side, height: side))
        frames.append(CGRect(x: side, y: origin, width: side, height: side))
        frames.append(CGRect(x: 0, y: origin, width: side, height: side))
        return frames
    }
}
