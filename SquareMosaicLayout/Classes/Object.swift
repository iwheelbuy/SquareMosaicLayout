import Foundation

public let SquareMosaicLayoutSectionBacker = "SquareMosaicLayout.SquareMosaicLayoutSectionBacker"
public let SquareMosaicLayoutSectionFooter = "SquareMosaicLayout.SquareMosaicLayoutSectionFooter"
public let SquareMosaicLayoutSectionHeader = "SquareMosaicLayout.SquareMosaicLayoutSectionHeader"

class SquareMosaicObject {
    
    fileprivate enum SupplementaryKind {
        
        case backer, footer, header
        
        var value: String {
            switch self {
            case .backer:   return SquareMosaicLayoutSectionBacker
            case .footer:   return SquareMosaicLayoutSectionFooter
            case .header:   return SquareMosaicLayoutSectionHeader
            }
        }
    }
    
    fileprivate lazy var attributesForCells = [[UICollectionViewLayoutAttributes]]()
    fileprivate lazy var attributesForSupplementary = [UICollectionViewLayoutAttributes]()
    fileprivate lazy var direction: SquareMosaicDirection = .vertical
    fileprivate lazy var size: CGSize = .zero
    fileprivate lazy var total: CGFloat = 0.0
    
    init(capacity: [Int], dataSource: SquareMosaicDataSource?, direction: SquareMosaicDirection, size: CGSize) {
        self.direction = direction
        self.size = size
        guard let dataSource = dataSource else { return }
        let sections = capacity.count
        addSeparatorSection(.top, dataSource: dataSource, sections: sections)
        for section in 0 ..< sections {
            addSeparatorSection(.middle, dataSource: dataSource, section: section, sections: sections)
            let sectionOffset: CGFloat = self.total
            addSupplementary(.header, dataSource: dataSource, section: section)
            let pattern: SquareMosaicPattern = dataSource.pattern(section: section)
            let rows: Int = capacity[section]
            addSeparatorBlock(.top, pattern: pattern, rows: rows)
            addAttributes(pattern, rows: rows, section: section)
            addSeparatorBlock(.bottom, pattern: pattern, rows: rows)
            addSupplementary(.footer, dataSource: dataSource, section: section)
            addSupplementaryBackground(.backer, dataSource: dataSource, offset: sectionOffset, section: section)
        }
        addSeparatorSection(.bottom, dataSource: dataSource, sections: sections)
    }
}

// MARK: - External

extension SquareMosaicObject {
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < attributesForCells.count else { return  nil }
        guard indexPath.row < attributesForCells[indexPath.section].count else { return nil }
        return attributesForCells[indexPath.section][indexPath.row]
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = attributesForCells.flatMap({$0}) + attributesForSupplementary
        return attributes
            .filter({ $0.frame.intersects(rect) })
    }
    
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesForSupplementary
            .filter({ $0.indexPath == indexPath })
            .filter({ $0.representedElementKind == elementKind })
            .first
    }
    
    var layoutTotal: CGFloat {
        return total
    }
}

// MARK: - Internal

fileprivate extension SquareMosaicPattern {
    
    func blocks(_ expectedFramesTotalCount: Int) -> [SquareMosaicBlock] {
        let patternBlocks: [SquareMosaicBlock] = blocks()
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

fileprivate extension SquareMosaicObject {
    
    func addAttributes(_ pattern: SquareMosaicPattern, rows: Int, section: Int) {
        var attributes = [UICollectionViewLayoutAttributes]()
        var row: Int = 0
        let blocks = pattern.blocks(rows)
        for (index, block) in blocks.enumerated() {
            guard row < rows else { break }
            addSeparatorBlock(.middle, block: index, blocks: blocks.count, pattern: pattern)
            let side = self.direction == .vertical ? self.size.width : self.size.height
            let frames = block.frames(origin: self.total, side: side)
            var total: CGFloat = 0
            for x in 0..<block.frames() {
                guard row < rows else { break }
                let indexPath = IndexPath(row: row, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = frames[x]
                attribute.zIndex = 0
                switch self.direction {
                case .vertical:
                    let dy = attribute.frame.origin.y + attribute.frame.height - self.total
                    total = dy > total ? dy : total
                case .horizontal:
                    let dx = attribute.frame.origin.x + attribute.frame.width - self.total
                    total = dx > total ? dx : total
                }
                attributes.append(attribute)
                row += 1
            }
            self.total += total
        }
        attributesForCells.append(attributes)
    }
    
    func addSeparatorBlock(_ type: SquareMosaicSeparatorType, block: Int = 0, blocks: Int = 0, pattern: SquareMosaicPattern, rows: Int = 0) {
        guard let separator = pattern.separator?(type) else { return }
        switch (type, rows > 0, block > 0, block < blocks) {
        case (.top, true, _, _):        self.total += separator
        case (.middle, _, true, true):  self.total += separator
        case (.bottom, true, _, _):     self.total += separator
        default:                        break
        }
    }
    
    func addSeparatorSection(_ type: SquareMosaicSeparatorType, dataSource: SquareMosaicDataSource, section: Int = 0, sections: Int) {
        guard sections > 0, let separator = dataSource.separator?(type) else { return }
        switch (type, section > 0, section < sections) {
        case (.top, _, _):          self.total += separator
        case (.middle, true, true): self.total += separator
        case (.bottom, _, _):       self.total += separator
        default:                    break
        }
    }
    
    func addSupplementaryBackground(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, offset: CGFloat, section: Int) {
        guard let background = dataSource.background?(section: section), background == true else { return }
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attributes.zIndex = -1
        switch self.direction {
        case .vertical:
            let origin = CGPoint(x: 0.0, y: offset)
            let size = CGSize(width: self.size.width, height: self.total - offset)
            attributes.frame = CGRect(origin: origin, size: size)
        case .horizontal:
            let origin = CGPoint(x: offset, y: 0.0)
            let size = CGSize(width: self.total - offset, height: self.size.height)
            attributes.frame = CGRect(origin: origin, size: size)
        }
        attributesForSupplementary.append(attributes)
    }
    
    func addSupplementary(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, section: Int) {
        guard let supplementary = getSupplementary(kind, dataSource: dataSource, section: section) else { return }
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attributes.zIndex = 1
        switch self.direction {
        case .vertical:
            let frame = supplementary.frame(origin: self.total, side: self.size.width)
            attributes.frame = frame
            self.total += (frame.origin.y + frame.height - self.total)
        case .horizontal:
            let frame = supplementary.frame(origin: self.total, side: self.size.height)
            attributes.frame = frame
            self.total += (frame.origin.x + frame.width - self.total)
        }
        attributesForSupplementary.append(attributes)
    }
    
    func getSupplementary(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, section: Int) -> SquareMosaicSupplementary? {
        switch kind {
        case .footer:   return dataSource.footer?(section: section)
        case .header:   return dataSource.header?(section: section)
        default:        return nil
        }
    }
}
