//
//  SquareMosaicLayout.swift
//

import UIKit

public protocol SquareMosaicBlock {
    
    func frames() -> Int
    func frames(origin: CGFloat, width: CGFloat) -> [CGRect]
}

public protocol SquareMosaicPattern {
    
    var blocks: [SquareMosaicBlock] { get }
}

public protocol SquareMosaicLayoutDataSource: class {
    
    func pattern() -> SquareMosaicPattern
}

public protocol SquareMosaicLayoutDelegate: class {
    
    func layoutHeight(_ height: CGFloat) -> Void
}

public class SquareMosaicLayout: UICollectionViewLayout {
    
    public weak var dataSource: SquareMosaicLayoutDataSource?
    public weak var delegate: SquareMosaicLayoutDelegate? {
        didSet {
            delegate?.layoutHeight(object.height)
        }
    }
    private lazy var object: SquareMosaicLayoutObject = SquareMosaicLayoutObject()
    
    override public var collectionViewContentSize: CGSize {
        guard let view = collectionView else { return .zero }
        return CGSize(width: view.layoutWidth, height: object.height)
    }
    
    override public func invalidateLayout() {
        super.invalidateLayout()
        object = SquareMosaicLayoutObject()
    }
    
    override public func prepare() {
        let capacity = collectionView?.capacity ?? [Int]()
        let pattern = dataSource?.pattern()
        let width = collectionView?.layoutWidth ?? 0.0
        object = SquareMosaicLayoutObject(capacity: capacity, pattern: pattern, width: width)
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return object.layoutAttributesForItem(at: indexPath)
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return object.layoutAttributesForElements(in: rect)
    }
}

private extension SquareMosaicPattern {
    
    func layouts(_ expectedFramesTotalCount: Int) -> [SquareMosaicBlock] {
        let patternBlocks: [SquareMosaicBlock] = blocks
        let patternFramesCount: Int = patternBlocks.map({$0.frames()}).reduce(0, +)
        var layoutTypes = [SquareMosaicBlock]()
        var count: Int = 0
        repeat {
            layoutTypes.append(contentsOf: patternBlocks)
            count += patternFramesCount
        } while (count < expectedFramesTotalCount)
        return layoutTypes
    }
}

class SquareMosaicLayoutObject {
    
    lazy var cache = [[UICollectionViewLayoutAttributes]]()
    lazy var height: CGFloat  = 0.0
    
    required init(capacity: [Int] = [Int](), pattern: SquareMosaicPattern? = nil, width: CGFloat = 0.0) {
        guard let pattern = pattern else { return }
        for section in 0..<capacity.count {
            var attributes = [UICollectionViewLayoutAttributes]()
            let rows = capacity[section]
            var row: Int = 0
            let layouts = pattern.layouts(rows)
            for layout in layouts {
                guard row < rows else { break }
                let frames = layout.frames(origin: self.height, width: width)
                var height: CGFloat = 0
                for x in 0..<layout.frames() {
                    guard row < rows else { break }
                    let indexPath = IndexPath(row: row, section: section)
                    let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attribute.frame = frames[x]
                    let dy = attribute.frame.origin.y + attribute.frame.height - self.height
                    height = dy > height ? dy : height
                    attributes.append(attribute)
                    row += 1
                }
                self.height += height
            }
            cache.append(attributes)
        }
    }
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < cache.count else { return  nil }
        guard indexPath.row < cache[indexPath.section].count else { return nil }
        return cache[indexPath.section][indexPath.row]
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.flatMap({$0}).filter({$0.frame.intersects(rect)})
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
