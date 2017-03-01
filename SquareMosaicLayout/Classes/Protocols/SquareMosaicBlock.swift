//
//  SquareMosaicBlock.swift
//

import Foundation

public protocol SquareMosaicBlock {
    
    func frames() -> Int
    func frames(origin: CGFloat, width: CGFloat) -> [CGRect]
}
