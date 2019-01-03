import UIKit

open class SMLayout: UICollectionViewLayout {

    private let aspectForced: CGFloat?
    private let direction: SMLayoutDirection
    private var object: SMLayoutObject? = nil
    private var visible: SMLayoutVisible? = nil
    public weak var source: SMLayoutSource?
    public weak var delegate: SMLayoutDelegate? {
        didSet {
            delegate?.smLayoutDelegateChanged(collectionViewContentSize: collectionViewContentSize)
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return object?.smLayoutContentSize() ?? .zero
    }
    
    public required init(aspect: CGFloat? = nil, direction: SMLayoutDirection = .vertical) {
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
                if object.aspect == aspect, object.dimension == dimension, object.source === source, let visible = self.visible {
                    if object.smLayoutUpdateRequired(visible: visible) {
                        self.object?.smLayoutUpdated(visible: visible)
                    }
                }
            } else {
                self.object = SMLayoutObject(aspect: aspect, dimension: dimension, direction: direction, source: source, visible: visible)
            }
        } else {
            self.object = nil
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.smLayoutAttributesForItem(indexPath: indexPath)
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object?.smLayoutAttributesForElement(rect: rect)
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object?.smLayoutAttributesForSupplementary(elementKind: elementKind, indexPath: indexPath)
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
        let direction = self.direction
        guard let visible = SMLayoutVisible(bounds: bounds, direction: direction) else {
            return
        }
        self.visible = visible
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        let bounds = newBounds
        guard let visible = SMLayoutVisible(bounds: bounds, direction: direction) else {
            return false
        }
        return object?.smLayoutUpdateRequired(visible: visible) ?? false
    }
}

private extension SMLayout {
    
    var aspect: CGFloat? {
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
    
    var dimension: SMLayoutDimension? {
        switch collectionView {
        case .some(let collectionView):
            return SMLayoutDimension(collectionView: collectionView)
        case .none:
            return nil
        }
    }
}
