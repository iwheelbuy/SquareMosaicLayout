//
//  SquareMosaicLayoutDataSource.swift
//

import Foundation

public protocol SquareMosaicLayoutDataSource: class {
    
    func footer(section: Int) -> SquareMosaicSupplementary?
    func header(section: Int) -> SquareMosaicSupplementary?
    func pattern(section: Int) -> SquareMosaicPattern
}
