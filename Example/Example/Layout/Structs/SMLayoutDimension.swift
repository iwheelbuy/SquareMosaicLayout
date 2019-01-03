import Foundation
import UIKit
/// Размерность коллекции
struct SMLayoutDimension {
    
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

    subscript(section: Int) -> Int {
        return array.count > section ? array[section] : 0
    }
    
    var sections: Int {
        return array.count
    }
}

extension SMLayoutDimension: Equatable {
    
    static func ==(lhs: SMLayoutDimension, rhs: SMLayoutDimension) -> Bool {
        return lhs.array == rhs.array
    }
}
