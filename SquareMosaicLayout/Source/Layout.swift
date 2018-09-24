import UIKit

struct SMLVisible {
    
    let length: CGFloat
    let origin: CGFloat
    
    var range: ClosedRange<CGFloat> {
        return origin ... length + origin
    }
    
    init?(bounds: CGRect, insets: UIEdgeInsets, size: CGSize, vertical: Bool) {
        let origin: CGFloat
        let length: CGFloat
        switch vertical {
        case true:
            origin = max(0, bounds.origin.y + insets.top)
            length = min(size.height, bounds.height - insets.bottom - insets.top)
        case false:
            origin = max(0, bounds.origin.x + insets.left)
            length = min(size.width, bounds.width - insets.right - insets.left)
        }
        guard length > 0 else {
            return nil
        }
        self.origin = origin
        self.length = length
    }
}

open class SquareMosaicLayout: UICollectionViewLayout {

    private let aspect: CGFloat?
    private var object: SMLObject? = nil
    private let vertical: Bool
    private var visible: SMLVisible? = nil
    public weak var source: SMLSource?
    public weak var delegate: SMLDelegate? {
        didSet {
            delegate?.smlDelegateChanged(collectionViewContentSize: collectionViewContentSize)
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return object?.smlContentSize() ?? .zero
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
            let object = SMLObject(dimension: dimension, direction: direction, source: source)
            switch visible {
            case .none:
                self.object = object
            case .some(let visible):
                self.object = object.updated(visible: visible)
            }
        } else {
            self.object = nil
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.smlAttributesForItem(indexPath: indexPath)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object?.smlAttributesForElement(rect: rect)
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.smlAttributesForSupplementary(elementKind: elementKind, indexPath: indexPath)
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView?.contentOffset ?? CGPoint.zero
    }
    
    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        guard #available(iOS 11.0, *), let collectionView = collectionView else {
            return
        }
        let bounds = collectionView.bounds
        let insets = collectionView.adjustedContentInset
        let size = collectionViewContentSize
        self.visible = SMLVisible(bounds: bounds, insets: insets, size: size, vertical: vertical) ?? self.visible
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard #available(iOS 11.0, *), let collectionView = collectionView else {
            return false
        }
        let bounds = newBounds
        let insets = collectionView.adjustedContentInset
        let size = collectionViewContentSize
        guard let visible = SMLVisible(bounds: bounds, insets: insets, size: size, vertical: vertical) else {
            return false
        }
        return object?.smlAttributesInvalidationRequired(visible: visible) ?? false
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
    
    var direction: SMLObjectDirection? {
        if let aspect = self.aspect {
            return SMLObjectDirection(aspect: aspect, vertical: vertical)
        }
        guard let collectionView = collectionView else {
            return nil
        }
        let aspect = vertical ? collectionView.desiredWidth : collectionView.desiredHeight
        return SMLObjectDirection(aspect: aspect, vertical: vertical)
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
