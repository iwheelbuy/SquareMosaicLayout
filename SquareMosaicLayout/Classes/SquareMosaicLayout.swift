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
    private var size: CGSize? = nil
    
    override open var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: object.height)
    }
    
    public init(size: CGSize? = nil) {
        self.size = size
        super.init()
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override open func prepare() {
        let capacity = collectionView?.capacity ?? [Int]()
        var width = collectionView?.layoutWidth ?? 0.0
        width = size?.width ?? width
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
