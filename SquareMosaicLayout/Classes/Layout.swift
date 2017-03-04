import UIKit

open class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicDataSource?
    public weak var delegate: SquareMosaicDelegate? {
        didSet {
            delegate?.layoutHeight(object?.layoutHeight ?? 0.0)
        }
    }
    fileprivate var object: SquareMosaicObject?
    fileprivate var size: CGSize? = nil
    
    override open var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: object?.layoutHeight ?? 0.0)
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
        let width = size?.width ?? collectionView?.layoutWidth ?? 0.0
        object = SquareMosaicObject(capacity: capacity, dataSource: dataSource, width: width)
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.layoutAttributesForItem(at: indexPath)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object?.layoutAttributesForElements(in: rect)
    }
    
    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView?.contentOffset ?? CGPoint.zero
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
    
    var layoutWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}
