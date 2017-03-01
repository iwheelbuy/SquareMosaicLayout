//
//  SquareMosaicLayoutPatterns.swift
//

import SquareMosaicLayout

class SnakeSquareMosaicSupplementary: SquareMosaicSupplementary {
    
    func frame(origin: CGFloat, width: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: width, height: width / 4.0)
    }
}

class SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    var blocks: [SquareMosaicBlock] {
        return [
            OneTwoSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock(),
            TwoOneSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock()
        ]
    }
}

class TripleSquareMosaicPattern: SquareMosaicPattern {
    
    var blocks: [SquareMosaicBlock] {
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
    
    private var width: CGFloat?
    private var max: CGFloat = 0.0
    private var min: CGFloat = 0.0
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        if self.width == nil || self.width! != width {
            self.width = width
            min = width / 3.0
            max = width - min
        }
        return frames(origin: origin, max: max, min: min)
    }
    
    private func frames(origin: CGFloat, max: CGFloat, min: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: max, height: max))
        frames.append(CGRect(x: max, y: origin, width: min, height: min))
        frames.append(CGRect(x: max, y: origin + max - min, width: min, height: min))
        return frames
    }
}

public class TwoOneSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }

    private var width: CGFloat?
    private var max: CGFloat = 0.0
    private var min: CGFloat = 0.0
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        if self.width == nil || self.width! != width {
            self.width = width
            min = width / 3.0
            max = width - min
        }
        return frames(origin: origin, max: max, min: min)
    }
    
    private func frames(origin: CGFloat, max: CGFloat, min: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: min, height: min))
        frames.append(CGRect(x: 0, y: origin + max - min, width: min, height: min))
        frames.append(CGRect(x: min, y: origin, width: max, height: max))
        return frames
    }
}

public class ThreeLeftSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    private var width: CGFloat?
    private var side: CGFloat = 0.0
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        if self.width == nil || self.width! != width {
            self.width = width
            side = width / 3.0
        }
        return frames(origin: origin, side: side)
    }
    
    private func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: side, height: side))
        frames.append(CGRect(x: side, y: origin, width: side, height: side))
        frames.append(CGRect(x: side + side, y: origin, width: side, height: side))
        return frames
    }
}

public class ThreeRightSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    private var width: CGFloat?
    private var side: CGFloat = 0.0
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        if self.width == nil || self.width! != width {
            self.width = width
            side = width / 3.0
        }
        return frames(origin: origin, side: side)
    }
    
    private func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: side + side, y: origin, width: side, height: side))
        frames.append(CGRect(x: side, y: origin, width: side, height: side))
        frames.append(CGRect(x: 0, y: origin, width: side, height: side))
        return frames
    }
}
