//
//  SquareMosaicLayoutPatterns.swift
//

import Foundation

public struct SnakeSquareMosaicPattern: SquareMosaicPattern {
   
   public init() {
      //
   }
   
   public var array: [SquareMosaicType] {
      return [
         OneTwoSquareMosaicType(),
         ThreeRightSquareMosaicType(),
         TwoOneSquareMosaicType(),
         ThreeRightSquareMosaicType()
      ]
   }
}

public struct TripleSquareMosaicPattern: SquareMosaicPattern {
   
   public init() {
      //
   }
   
   public var array: [SquareMosaicType] {
      return [
         ThreeLeftSquareMosaicType(),
         ThreeRightSquareMosaicType(),
      ]
   }
}

public struct OneTwoSquareMosaicType: SquareMosaicType {
   
   public var weight: UInt {
      return 3
   }
   
   public func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
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

public struct TwoOneSquareMosaicType: SquareMosaicType {
   
   public var weight: UInt {
      return 3
   }
   
   public func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
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

public struct ThreeLeftSquareMosaicType: SquareMosaicType {
   
   public var weight: UInt {
      return 3
   }
   
   public func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
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

public struct ThreeRightSquareMosaicType: SquareMosaicType {
   
   public var weight: UInt {
      return 3
   }
   
   public func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames {
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
