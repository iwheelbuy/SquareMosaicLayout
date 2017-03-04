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
    fileprivate lazy var height: CGFloat  = 0.0
    
    required init(capacity: [Int] = [Int](), dataSource: SquareMosaicDataSource? = nil, width: CGFloat = 0.0) {
        guard let dataSource = dataSource else { return }
        let sections = capacity.count
        addSeparatorSection(.top, dataSource: dataSource, sections: sections)
        for section in 0 ..< sections {
            addSeparatorSection(.middle, dataSource: dataSource, section: section, sections: sections)
            let sectionOffset: CGFloat = self.height
            addSupplementary(.header, dataSource: dataSource, section: section, width: width)
            let pattern: SquareMosaicPattern = dataSource.pattern(section: section)
            let rows: Int = capacity[section]
            addSeparatorBlock(.top, pattern: pattern, rows: rows)
            addAttributes(pattern, rows: rows, section: section, width: width)
            addSeparatorBlock(.bottom, pattern: pattern, rows: rows)
            addSupplementary(.footer, dataSource: dataSource, section: section, width: width)
            addSupplementaryBackground(.backer, dataSource: dataSource, offset: sectionOffset, section: section, width: width)
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
        return attributes.filter({$0.frame.intersects(rect)})
    }
    
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesForSupplementary
            .filter({ $0.indexPath == indexPath })
            .filter({ $0.representedElementKind == elementKind })
            .first
    }
    
    var layoutHeight: CGFloat {
        return height
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
    
    func addAttributes(_ pattern: SquareMosaicPattern, rows: Int, section: Int, width: CGFloat) {
        var attributes = [UICollectionViewLayoutAttributes]()
        var row: Int = 0
        let blocks = pattern.blocks(rows)
        for (index, block) in blocks.enumerated() {
            guard row < rows else { break }
            addSeparatorBlock(.middle, block: index, blocks: blocks.count, pattern: pattern)
            let frames = block.frames(origin: self.height, width: width)
            var height: CGFloat = 0
            for x in 0..<block.frames() {
                guard row < rows else { break }
                let indexPath = IndexPath(row: row, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attribute.frame = frames[x]
                attribute.zIndex = 0
                let dy = attribute.frame.origin.y + attribute.frame.height - self.height
                height = dy > height ? dy : height
                attributes.append(attribute)
                row += 1
            }
            self.height += height
        }
        attributesForCells.append(attributes)
    }
    
    func addSeparatorBlock(_ type: SquareMosaicSeparatorType, block: Int = 0, blocks: Int = 0, pattern: SquareMosaicPattern, rows: Int = 0) {
        guard let separator = pattern.separator?(type) else { return }
        switch (type, rows > 0, block > 0, block < blocks) {
        case (.top, true, _, _):        self.height += separator
        case (.middle, _, true, true):  self.height += separator
        case (.bottom, true, _, _):     self.height += separator
        default:                        break
        }
    }
    
    func addSeparatorSection(_ type: SquareMosaicSeparatorType, dataSource: SquareMosaicDataSource, section: Int = 0, sections: Int) {
        guard sections > 0, let separator = dataSource.separator?(type) else { return }
        switch (type, section > 0, section < sections) {
        case (.top, _, _):          self.height += separator
        case (.middle, true, true): self.height += separator
        case (.bottom, _, _):       self.height += separator
        default:                    break
        }
    }
    
    func addSupplementaryBackground(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, offset: CGFloat, section: Int, width: CGFloat) {
        guard let background = dataSource.background?(section: section), background == true else { return }
        let height = self.height - offset
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attributes.frame = CGRect(x: 0.0, y: offset, width: width, height: height)
        attributes.zIndex = -1
        attributesForSupplementary.append(attributes)
    }
    
    func addSupplementary(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, section: Int, width: CGFloat) {
        guard let supplementary = getSupplementary(kind, dataSource: dataSource, section: section) else { return }
        let indexPath = IndexPath(item: 0, section: section)
        let frame = supplementary.frame(origin: self.height, width: width)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attributes.frame = frame
        attributes.zIndex = 1
        self.height += (frame.origin.y + frame.height - self.height)
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
