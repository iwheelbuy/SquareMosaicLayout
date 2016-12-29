//
//  SquareMosaicLayoutPatterns.swift
//

import Foundation

struct SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    var array: [SquareMosaicType] {
        return [
            OneTwoSquareMosaicType(),
            ThreeRightSquareMosaicType(),
            TwoOneSquareMosaicType(),
            ThreeRightSquareMosaicType()
        ]
    }
}

struct TripleSquareMosaicPattern: SquareMosaicPattern {
    
    var array: [SquareMosaicType] {
        return [
            ThreeLeftSquareMosaicType(),
            ThreeRightSquareMosaicType(),
        ]
    }
}

struct OneTwoSquareMosaicType: SquareMosaicType {
    
    var weight: UInt {
        return 3
    }
    
    func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
        let sideMin = (width - padding - padding) / 3.0
        let sideMax = width - padding - sideMin
        var frames: [CGRect] = []
        var height: [CGFloat] = []
        frames += [CGRect(x: 0, y: origin, width: sideMax, height: sideMax)]
        height += [sideMax]
        frames += [CGRect(x: sideMax + padding, y: origin, width: sideMin, height: sideMin)]
        height += [sideMax]
        frames += [CGRect(x: sideMax + padding, y: origin + sideMax - sideMin, width: sideMin, height: sideMin)]
        height += [sideMax]
        return SquareMosaicTypeFrames(frames: frames, height: height)
    }
}

struct TwoOneSquareMosaicType: SquareMosaicType {
    
    var weight: UInt {
        return 3
    }
    
    func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
        let sideMin = (width - padding - padding) / 3.0
        let sideMax = width - padding - sideMin
        var frames: [CGRect] = []
        var height: [CGFloat] = []
        frames += [CGRect(x: 0, y: origin, width: sideMin, height: sideMin)]
        height += [sideMin]
        frames += [CGRect(x: 0, y: origin + sideMax - sideMin, width: sideMin, height: sideMin)]
        height += [sideMax]
        frames += [CGRect(x: sideMin + padding, y: origin, width: sideMax, height: sideMax)]
        height += [sideMax]
        return SquareMosaicTypeFrames(frames: frames, height: height)
    }
}

struct ThreeLeftSquareMosaicType: SquareMosaicType {
    
    var weight: UInt {
        return 3
    }
    
    func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
        let side = (width - padding - padding) / 3.0
        var frames: [CGRect] = []
        var height: [CGFloat] = []
        frames += [CGRect(x: 0, y: origin, width: side, height: side)]
        height += [side]
        frames += [CGRect(x: side + padding, y: origin, width: side, height: side)]
        height += [side]
        frames += [CGRect(x: side + padding + side + padding, y: origin, width: side, height: side)]
        height += [side]
        return SquareMosaicTypeFrames(frames: frames, height: height)
    }
}

struct ThreeRightSquareMosaicType: SquareMosaicType {
    
    var weight: UInt {
        return 3
    }
    
    func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
        let side = (width - padding - padding) / 3.0
        var frames: [CGRect] = []
        var height: [CGFloat] = []
        frames += [CGRect(x: side + padding + side + padding, y: origin, width: side, height: side)]
        height += [side]
        frames += [CGRect(x: side + padding, y: origin, width: side, height: side)]
        height += [side]
        frames += [CGRect(x: 0, y: origin, width: side, height: side)]
        height += [side]
        return SquareMosaicTypeFrames(frames: frames, height: height)
    }
}
