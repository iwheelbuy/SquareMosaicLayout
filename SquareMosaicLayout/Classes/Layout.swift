import UIKit

open class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicDataSource?
    public weak var delegate: SquareMosaicDelegate? {
        didSet {
            delegate?.layoutHeight(object.height)
        }
    }
    internal lazy var object: SquareMosaicObject = SquareMosaicObject()
    fileprivate var size: CGSize? = nil
    
    override open var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: object.height)
    }
    
    public init(size: CGSize? = nil) {
        self.size = size
        super.init()
        self.register(DecorationView.self, forDecorationViewOfKind: UICollectionElementKindSectionBackground)
    }
    
    public convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override open func prepare() {
        let capacity = collectionView?.capacity ?? [Int]()
        var width = collectionView?.layoutWidth ?? 0.0
        width = size?.width ?? width
        object = SquareMosaicObject(capacity: capacity, dataSource: dataSource, width: width)
    }
    
    override open func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
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
    
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView?.contentOffset ?? CGPoint.zero
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
