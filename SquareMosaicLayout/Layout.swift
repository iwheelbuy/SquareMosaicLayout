import UIKit

open class SquareMosaicLayout: UICollectionViewLayout {

    private let aspect: CGFloat?
    private var attributes: (SMLAttributes & SMLContentSize)? = nil
    private let vertical: Bool
    public weak var source: SMLSource?
    public weak var delegate: SMLDelegate? {
        didSet {
            delegate?.smlDelegateChanged(collectionViewContentSize: collectionViewContentSize)
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return attributes?.smlContentSize() ?? .zero
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
            self.attributes = SMLObjectOld(dimension: dimension, direction: direction, source: source)
        } else {
            self.attributes = nil
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes?.smlAttributesForItem(indexPath: indexPath)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes?.smlAttributesForElement(rect: rect)
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes?.smlAttributesForSupplementary(elementKind: elementKind, indexPath: indexPath)
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

private extension UICollectionView {
    
    var desiredHeight: CGFloat {
        return bounds.height - contentInset.top - contentInset.bottom
    }
    
    var desiredWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}
