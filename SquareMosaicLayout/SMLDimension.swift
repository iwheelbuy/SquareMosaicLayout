import Foundation

struct SMLDimension {
    
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
    
    func smlDimensionItems(section: Int) -> Int {
        return array.count > section ? array[section] : 0
    }
    
    func smlDimensionSections() -> Int {
        return array.count
    }
    
    var numberOfItemsInSections: [Int] {
        return array
    }
}
