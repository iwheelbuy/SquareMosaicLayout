//
//  SquareMosaicLayout.swift
//

import UIKit

public protocol SquareMosaicTypeFrame {
    
    var frame: CGRect { get }
    var height: CGFloat { get }
}

public protocol SquareMosaicType {
    
    func frames() -> Int
    func frames(origin: CGFloat, width: CGFloat) -> [SquareMosaicTypeFrame]
}

public protocol SquareMosaicPattern {
    
    var types: [SquareMosaicType] { get }
}

private extension SquareMosaicPattern {
    
    func layouts(_ expectedFramesTotalCount: Int) -> [SquareMosaicType] {
        let patternTypes = types
        let patternFramesCount = patternTypes.map({$0.frames()}).reduce(0, +)
        var layoutTypes = [SquareMosaicType]()
        var count: Int = 0
        repeat {
            layoutTypes.append(contentsOf: patternTypes)
            count += patternFramesCount
        } while (count < expectedFramesTotalCount)
        return layoutTypes
    }
}

public protocol SquareMosaicLayoutDataSource: class {
    
    func pattern() -> SquareMosaicPattern
}

public protocol SquareMosaicLayoutDelegate: class {
    
    func layoutHeight(_ height: CGFloat) -> Void
}

private extension UICollectionView {
    
    var layoutWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}

public class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicLayoutDataSource?
    public weak var delegate: SquareMosaicLayoutDelegate? {
        didSet {
            delegate?.layoutHeight(layoutHeight)
        }
    }
    private var cache: [[UICollectionViewLayoutAttributes]] = []
    private var layoutHeight: CGFloat  = 0.0
    
    override public var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: layoutHeight)
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
        layoutHeight = 0.0
    }
    
    override public func prepare() {
        guard let dataSource = dataSource else { return }
        guard let view = collectionView else { return }
        guard cache.isEmpty else { return }
        for section in 0..<view.numberOfSections {
            var attributes = [UICollectionViewLayoutAttributes]()
            let rows = view.numberOfItems(inSection: section)
            var row: Int = 0
            let layouts = dataSource.pattern().layouts(rows)
            for layout in layouts {
                guard row < rows else { break }
                let frames = layout.frames(origin: layoutHeight, width: view.layoutWidth)
                var height: CGFloat = 0
                for x in 0..<layout.frames() {
                    guard row < rows else { break }
                    let indexPath = IndexPath(row: row, section: section)
                    let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attribute.frame = frames[x].frame
                    height = frames[x].height > height ? frames[x].height : height
                    attributes.append(attribute)
                    row += 1
                }
                layoutHeight += height
            }
            cache.append(attributes)
        }
        delegate?.layoutHeight(layoutHeight)
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < cache.count else { return  nil }
        guard indexPath.row < cache[indexPath.section].count else { return nil }
        return cache[indexPath.section][indexPath.row]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.flatMap({$0}).filter({$0.frame.intersects(rect)})
    }
}
