//
//  File.swift
//  Pods
//
//  Created by Vasilyev Mikhail on 22.09.2018.
//

import Foundation

protocol SMLDimension {
    
    func smlNumberOfItems(section: Int) -> Int
    func smlNumberOfSection() -> Int
    
    var numberOfItemsInSections: [Int] { get }
}

struct Dimension: SMLDimension {
    
    private let array: [Int]
    
    init(collectionView: UICollectionView) {
        if collectionView.numberOfSections > 0 {
            self.array = Array(0 ..< collectionView.numberOfSections)
                .map({ [unowned collectionView] (section) -> Int in
                    return collectionView.numberOfItems(inSection: section)
                })
        } else {
            self.array = []
        }
    }
    
    func smlNumberOfItems(section: Int) -> Int {
        return array.count > section ? array[section] : 0
    }
    
    func smlNumberOfSection() -> Int {
        return array.count
    }
    
    var numberOfItemsInSections: [Int] {
        return array
    }
}

protocol SMLDirection {
    
    func smlDirectionAspect() -> CGFloat
    func smlDirectionVertical() -> Bool
}

struct Direction: SMLDirection {
    
    let aspect: CGFloat
    let vertical: Bool
    
    init(aspect: CGFloat, vertical: Bool) {
        self.aspect = aspect
        self.vertical = vertical
    }
    
    func smlDirectionAspect() -> CGFloat {
        return aspect
    }
    
    func smlDirectionVertical() -> Bool {
        return vertical
    }
}
