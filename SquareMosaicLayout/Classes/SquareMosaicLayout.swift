//
//  SquareMosaicLayout.swift
//

import UIKit

open class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicLayoutDataSource?
    public weak var delegate: SquareMosaicLayoutDelegate? {
        didSet {
            delegate?.layoutHeight(object.height)
        }
    }
    private lazy var object: SquareMosaicLayoutObject = SquareMosaicLayoutObject()
    
    override open var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: object.height)
    }
    
    override open func invalidateLayout() {
        super.invalidateLayout()
        object = SquareMosaicLayoutObject()
    }
    
    override open func prepare() {
        let capacity = collectionView?.capacity ?? [Int]()
        let width = collectionView?.layoutWidth ?? 0.0
        object = SquareMosaicLayoutObject(capacity: capacity, dataSource: dataSource, width: width)
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView?.contentOffset ?? CGPoint.zero
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object.layoutAttributesForItem(at: indexPath)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object.layoutAttributesForElements(in: rect)
    }
    
    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
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
