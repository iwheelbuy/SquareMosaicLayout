//
//  SquareMosaicLayoutPatterns.swift
//

import SquareMosaicLayout

private struct SquareMosaicTypeFrameStruct: SquareMosaicTypeFrame {
    
    let frame: CGRect
    let height: CGFloat
}

struct SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    var types: [SquareMosaicType] {
        return [
            OneTwoSquareMosaicType(),
            ThreeRightSquareMosaicType(),
            TwoOneSquareMosaicType(),
            ThreeRightSquareMosaicType()
        ]
    }
}

struct TripleSquareMosaicPattern: SquareMosaicPattern {
    
    var types: [SquareMosaicType] {
        return [
            ThreeLeftSquareMosaicType(),
            ThreeRightSquareMosaicType(),
        ]
    }
}

public struct OneTwoSquareMosaicType: SquareMosaicType {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicTypeFrame] {
        let sideMin = width / 3.0
        let sideMax = width - sideMin
        var frames = [SquareMosaicTypeFrame]()
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: 0, y: origin, width: sideMax, height: sideMax),
                height: sideMax
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: sideMax, y: origin, width: sideMin, height: sideMin),
                height: sideMax
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: sideMax, y: origin + sideMax - sideMin, width: sideMin, height: sideMin),
                height: sideMax
            )
        )
        return frames
    }
}

public struct TwoOneSquareMosaicType: SquareMosaicType {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicTypeFrame] {
        let sideMin = width / 3.0
        let sideMax = width - sideMin
        var frames = [SquareMosaicTypeFrame]()
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: 0, y: origin, width: sideMin, height: sideMin),
                height: sideMin
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: 0, y: origin + sideMax - sideMin, width: sideMin, height: sideMin),
                height: sideMax
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: sideMin, y: origin, width: sideMax, height: sideMax),
                height: sideMax
            )
        )
        return frames
    }
}

public struct ThreeLeftSquareMosaicType: SquareMosaicType {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicTypeFrame] {
        let side = width / 3.0
        var frames = [SquareMosaicTypeFrame]()
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: 0, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: side, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: side + side, y: origin, width: side, height: side),
                height: side
            )
        )
        return frames
    }
}

public struct ThreeRightSquareMosaicType: SquareMosaicType {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicTypeFrame] {
        let side = width / 3.0
        var frames = [SquareMosaicTypeFrame]()
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: side + side, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: side, y: origin, width: side, height: side),
                height: side
            )
        )
        frames.append(
            SquareMosaicTypeFrameStruct(
                frame: CGRect(x: 0, y: origin, width: side, height: side),
                height: side
            )
        )
        return frames
    }
}
