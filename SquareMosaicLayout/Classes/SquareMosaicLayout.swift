//
//  SquareMosaicLayout.swift
//

import UIKit

public class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicLayoutDataSource?
    public weak var delegate: SquareMosaicLayoutDelegate? {
        didSet {
            delegate?.layoutHeight(object.height)
        }
    }
    private lazy var object: SquareMosaicLayoutObject = SquareMosaicLayoutObject()
    
    override public var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: object.height)
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        object = SquareMosaicLayoutObject()
    }
    
    override public func prepare() {
        let capacity = collectionView?.capacity ?? [Int]()
        let width = collectionView?.layoutWidth ?? 0.0
        object = SquareMosaicLayoutObject(capacity: capacity, dataSource: dataSource, width: width)
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object.layoutAttributesForItem(at: indexPath)
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object.layoutAttributesForElements(in: rect)
    }
    
    override public func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
}

private extension UICollectionView {
    
    var capacity: [Int] {
        var array = [Int]()
        for section in 0..<numberOfSections {
            array.append(numberOfItems(inSection: section))
        }
        return array
    }
    
    var layoutWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}
