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
    
    var array: [SquareMosaicType] { get }
}

private extension SquareMosaicPattern {
    
    var weight: Int {
        return array.map{$0.frames()}.reduce(0, +)
    }
    
    func layouts(_ weight: Int) -> [SquareMosaicType] {
        let weightPattern: Int = self.weight
        var layouts: [SquareMosaicType] = []
        var weightLayout: Int = 0
        repeat {
            layouts += array
            weightLayout += weightPattern
        } while (weightLayout < weight)
        return layouts
    }
}

public protocol SquareMosaicLayoutDelegate: class {
    
    var pattern: SquareMosaicPattern { get }
}

private extension UICollectionView {
    
    var layoutWidth: CGFloat {
        return bounds.width - contentInset.left - contentInset.right
    }
}

public class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var delegate: SquareMosaicLayoutDelegate?
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
        guard let delegate = delegate else { return }
        guard let view = collectionView else { return }
        guard cache.isEmpty else { return }
        for section in 0..<view.numberOfSections {
            var attributes = [UICollectionViewLayoutAttributes]()
            let rows = view.numberOfItems(inSection: section)
            var row: Int = 0
            let layouts = delegate.pattern.layouts(rows)
            for layout in layouts {
                guard row < rows else { break }
                let value = layout.frames(origin: layoutHeight, width: view.layoutWidth)
                var height: CGFloat = 0
                for x in 0..<layout.frames() {
                    guard row < rows else { break }
                    let indexPath = IndexPath(row: row, section: section)
                    let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attribute.frame = value[x].frame
                    height = value[x].height > height ? value[x].height : height
                    attributes.append(attribute)
                    row += 1
                }
                layoutHeight += height
            }
            cache.append(attributes)
        }
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
