import UIKit

struct SMLVisible {
    
    let length: CGFloat
    let origin: CGFloat
    
    var range: ClosedRange<CGFloat> {
        return origin ... length + origin
    }
    
    init?(bounds: CGRect, direction: SMLObjectDirection, insets: UIEdgeInsets, size: CGSize) {
        let origin: CGFloat
        let length: CGFloat
        switch direction {
        case .vertical:
            origin = max(0, bounds.origin.y + insets.top)
            length = min(size.height, bounds.height - insets.bottom - insets.top)
        case .horizontal:
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

    private let aspectForced: SMLObjectAspect?
    private var object: SMLObject? = nil
    private let direction: SMLObjectDirection
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
    
    public required init(aspect: SMLObjectAspect? = nil, direction: SMLObjectDirection = .vertical) {
        self.aspectForced = aspect
        self.direction = direction
        super.init()
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    open override func prepare() {
        if let aspect = self.aspect, let dimension = self.dimension, let source = source {
            if let object = self.object {
                if object.aspect == aspect, object.dimension == dimension, object.source === source {
                    if object.invalidationRequiredFor(visible: visible) {
                        object.updateFor(visible: visible)
                    }
                }
            } else {
                self.object = SMLObject(aspect: aspect, dimension: dimension, direction: direction, source: source, visible: visible)
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
        self.visible = SMLVisible(bounds: bounds, direction: direction, insets: insets, size: size) ?? self.visible
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard #available(iOS 11.0, *), let collectionView = collectionView else {
            return false
        }
        let bounds = newBounds
        let insets = collectionView.adjustedContentInset
        let size = collectionViewContentSize
        guard let visible = SMLVisible(bounds: bounds, direction: direction, insets: insets, size: size) else {
            return false
        }
        return object?.invalidationRequiredFor(visible: visible) ?? false
    }
}

private extension SquareMosaicLayout {
    
    var aspect: SMLObjectAspect? {
        guard let collectionView = collectionView else {
            return nil
        }
        let bounds = collectionView.bounds
        let contentInset = collectionView.contentInset
        switch direction {
        case .vertical:
            return bounds.width - contentInset.left - contentInset.right
        case .horizontal:
            return bounds.height - contentInset.top - contentInset.bottom
        }
    }
    
    var dimension: SMLDimension? {
        switch collectionView {
        case .some(let collectionView):
            return SMLDimension(collectionView: collectionView)
        case .none:
            return nil
        }
    }
}
