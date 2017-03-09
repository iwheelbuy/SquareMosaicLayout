import UIKit

open class SquareMosaicLayout: UICollectionViewLayout {
    
    fileprivate let direction: SquareMosaicDirection
    fileprivate var object: SquareMosaicObject? = nil
    fileprivate let size: CGSize?
    
    public weak var dataSource: SquareMosaicDataSource?
    public weak var delegate: SquareMosaicDelegate? {
        didSet {
            delegate?.layoutSize(layoutSize)
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return layoutSize
    }
    
    public init(direction: SquareMosaicDirection = .vertical, size: CGSize? = nil) {
        self.direction = direction
        self.size = size
        super.init()
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    open override func prepare() {
        let capacity = collectionView?.capacity ?? []
        let size = layoutSize
        object = SquareMosaicObject(capacity: capacity, dataSource: dataSource, direction: direction, size: size)
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.layoutAttributesForItem(at: indexPath)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object?.layoutAttributesForElements(in: rect)
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView?.contentOffset ?? CGPoint.zero
    }
}

fileprivate extension SquareMosaicLayout {
    
    var layoutSize: CGSize {
        switch direction {
        case .vertical:
            let height = object?.layoutTotal ?? 0.0
            let width = size?.width ?? collectionView?.layoutWidth ?? 0.0
            return CGSize(width: width, height: height)
        case .horizontal:
            let width = object?.layoutTotal ?? 0.0
            let height = size?.height ?? collectionView?.layoutHeight ?? 0.0
            return CGSize(width: width, height: height)
        }
    }
}

fileprivate extension UICollectionView {
    
    var capacity: [Int] {
        var array = [Int]()
        for section in 0..<numberOfSections {
            array.append(numberOfItems(inSection: section))
        }
        return array
    }
    
    var layoutHeight: CGFloat {
        return bounds.height - contentInset.top - contentInset.bottom
    }
    
    var layoutWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}
