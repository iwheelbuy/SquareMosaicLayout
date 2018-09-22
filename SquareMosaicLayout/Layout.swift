import UIKit

extension UICollectionView {
    
    var desiredHeight: CGFloat {
        return bounds.height - contentInset.top - contentInset.bottom
    }
    
    var desiredWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}

open class SquareMosaicLayout: UICollectionViewLayout {

    private let aspect: CGFloat?
    private var object: SMLObject? = nil
    private let vertical: Bool
    public weak var source: SMLSource?
    public weak var delegate: SMLDelegate? {
        didSet {
            delegate?.smlDelegateChanged(collectionViewContentSize: collectionViewContentSize)
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        switch collectionView {
        case .some(let collectionView):
            switch vertical {
            case false:
                return CGSize(width: object?.contentSize ?? 0, height: collectionView.desiredHeight)
            case true:
                return CGSize(width: collectionView.desiredWidth, height: object?.contentSize ?? 0)
            }
        case .none:
            return .zero
        }
    }
    
    public required init(aspect: CGFloat? = nil, vertical: Bool = true) {
        self.aspect = aspect
        self.vertical = vertical
        super.init()
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    open override func prepare() {
        if let dimension = self.dimension, let direction = self.direction, let source = source {
            self.object = SMLObject(dimension: dimension, direction: direction, source: source)
        } else {
            self.object = nil
        }
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

private extension SquareMosaicLayout {
    
    var dimension: SMLDimension? {
        switch collectionView {
        case .some(let collectionView):
            return SMLDimension(collectionView: collectionView)
        case .none:
            return nil
        }
    }
    
    var direction: SMLDirection? {
        if let aspect = self.aspect {
            return SMLDirection(aspect: aspect, vertical: vertical)
        }
        guard let collectionView = collectionView else {
            return nil
        }
        let aspect = vertical ? collectionView.desiredWidth : collectionView.desiredHeight
        return SMLDirection(aspect: aspect, vertical: vertical)
    }
}
