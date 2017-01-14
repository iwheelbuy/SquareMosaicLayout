//
//  SquareMosaicLayoutPatterns.swift
//

import SquareMosaicLayout

private struct SquareMosaicFrameStruct: SquareMosaicFrame {
    
    let frame: CGRect
    let height: CGFloat
}

struct SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    var types: [SquareMosaicBlock] {
        return [
            OneTwoSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock(),
            TwoOneSquareMosaicBlock(),
            ThreeRightSquareMosaicBlock()
        ]
    }
}

struct TripleSquareMosaicPattern: SquareMosaicPattern {
    
    var types: [SquareMosaicBlock] {
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
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicFrame] {
        let sideMin = width / 3.0
        let sideMax = width - sideMin
        var frames = [SquareMosaicFrame]()
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: 0, y: origin, width: sideMax, height: sideMax),
                height: sideMax
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: sideMax, y: origin, width: sideMin, height: sideMin),
                height: sideMax
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: sideMax, y: origin + sideMax - sideMin, width: sideMin, height: sideMin),
                height: sideMax
            )
        )
        return frames
    }
}

public struct TwoOneSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicFrame] {
        let sideMin = width / 3.0
        let sideMax = width - sideMin
        var frames = [SquareMosaicFrame]()
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: 0, y: origin, width: sideMin, height: sideMin),
                height: sideMin
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: 0, y: origin + sideMax - sideMin, width: sideMin, height: sideMin),
                height: sideMax
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: sideMin, y: origin, width: sideMax, height: sideMax),
                height: sideMax
            )
        )
        return frames
    }
}

public struct ThreeLeftSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicFrame] {
        let side = width / 3.0
        var frames = [SquareMosaicFrame]()
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: 0, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: side, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: side + side, y: origin, width: side, height: side),
                height: side
            )
        )
        return frames
    }
}

public struct ThreeRightSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicFrame] {
        let side = width / 3.0
        var frames = [SquareMosaicFrame]()
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: side + side, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: side, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicFrameStruct(
                frame: CGRect(x: 0, y: origin, width: side, height: side),
                height: side
            )
        )
        return frames
    }
}
