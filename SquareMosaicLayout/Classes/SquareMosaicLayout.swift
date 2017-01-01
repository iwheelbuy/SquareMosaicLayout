//
//  SquareMosaicLayout.swift
//

import UIKit

public typealias SquareMosaicTypeFrames = (frames: [CGRect], height: [CGFloat])

public protocol SquareMosaicType {
    
    var weight: UInt { get }
    func frames(origin: CGFloat, padding: CGFloat, width: CGFloat) -> SquareMosaicTypeFrames
}

public protocol SquareMosaicPattern {
    
    var array: [SquareMosaicType] { get }
}

private extension SquareMosaicPattern {
    
    var weight: UInt {
        return array.map{$0.weight}.reduce(0, +)
    }
    
    func layouts(_ weight: UInt) -> [SquareMosaicType] {
        let weightPattern: UInt = self.weight
        var layouts: [SquareMosaicType] = []
        var weightLayout: UInt = 0
        repeat {
            layouts += array
            weightLayout += weightPattern
        } while (weightLayout < weight)
        return layouts
    }
}

public protocol SquareMosaicLayoutDelegate: class {
    
    var padding: CGFloat { get }
    var pattern: SquareMosaicPattern { get }
}

public class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var delegate: SquareMosaicLayoutDelegate?
    private var itemAttributes: [[UICollectionViewLayoutAttributes]] = []
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var layoutHeight: CGFloat  = 0.0
    private var layoutWidth: CGFloat {
        return collectionWidth - collectionLeft - collectionRight
    }
    private var collectionLeft: CGFloat {
        return collectionView?.contentInset.left ?? 0.0
    }
    private var collectionRight: CGFloat {
        return collectionView?.contentInset.right ?? 0.0
    }
    private var collectionWidth: CGFloat {
        return collectionView?.bounds.width ?? UIScreen.main.bounds.width
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: layoutWidth, height: layoutHeight)
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        patternSizes = nil
        cache.removeAll()
        itemAttributes.removeAll()
        layoutHeight = 0.0
    }
    
    var patternSizes: [Int:CGSize]?
    lazy var patternWeight: Int = 0
    
    func size(_ indexPath: IndexPath) -> CGSize {
        if patternSizes == nil {
            guard let delegate = delegate else { fatalError("SquareMosaicLayout.delegate not set") }
            let padding = delegate.padding
            let pattern = delegate.pattern
            patternWeight = Int(pattern.weight)
            var index = 0
            patternSizes = [Int:CGSize]()
            for layout in pattern.array {
                let value = layout.frames(origin: 0, padding: padding, width: layoutWidth)
                for x in 0..<Int(layout.weight) {
                    patternSizes![index] = value.frames[x].size
                    index += 1
                }
            }
        }
        return patternSizes![indexPath.row % patternWeight]!
    }
    
    override public func prepare() {
        debugPrint(layoutWidth, collectionView?.contentSize.width)
        guard let delegate = delegate else { fatalError("SquareMosaicLayout.delegate not set") }
        guard cache.isEmpty else { return }
        for section in 0..<(collectionView?.numberOfSections ?? 0) {
            var rowAttributes = [UICollectionViewLayoutAttributes]()
            let weight: Int = collectionView?.numberOfItems(inSection: section) ?? 0
            var row: Int = 0
            let layouts = delegate.pattern.layouts(UInt(weight))
            for layout in layouts {
                if row >= weight { break }
                layoutHeight += layoutHeight > 0 ? delegate.padding : 0
                let value = layout.frames(origin: layoutHeight, padding: delegate.padding, width: layoutWidth)
                var height: CGFloat = 0
                for x in 0..<Int(layout.weight) {
                    if row >= weight { break }
                    let indexPath = IndexPath(row: row, section: section)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = value.frames[x]
                    height = value.height[x]
                    cache.append(attributes)
                    rowAttributes.append(attributes)
                    row += 1
                }
                layoutHeight += height
            }
            itemAttributes.append(rowAttributes)
        }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < itemAttributes.count else { return  nil }
        guard indexPath.row < itemAttributes[indexPath.section].count else { return nil }
        return itemAttributes[indexPath.section][indexPath.row]
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect ) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
