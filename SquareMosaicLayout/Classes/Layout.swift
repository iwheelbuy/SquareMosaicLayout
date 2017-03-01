import UIKit

open class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicDataSource?
    public weak var delegate: SquareMosaicDelegate? {
        didSet {
            delegate?.layoutHeight(object.height)
        }
    }
    fileprivate lazy var object: SquareMosaicObject = SquareMosaicObject()
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

final private class DecorationView: UICollectionReusableView {
    
    private var backgroundPainted: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard backgroundPainted == false else { return }
        guard let view = superview as? UICollectionView else { return }
        guard let layout = view.collectionViewLayout as? SquareMosaicLayout else { return }
        backgroundPainted = true
        guard let section = layout.object.decoration.filter({ $0.frame == frame }).map({ $0.indexPath.section }).first else { return }
        self.backgroundColor = layout.dataSource?.backgroundColor?(section: section)
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
