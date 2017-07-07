import Foundation

public let SquareMosaicLayoutSectionBacker = "SquareMosaicLayout.SquareMosaicLayoutSectionBacker"
public let SquareMosaicLayoutSectionFooter = "SquareMosaicLayout.SquareMosaicLayoutSectionFooter"
public let SquareMosaicLayoutSectionHeader = "SquareMosaicLayout.SquareMosaicLayoutSectionHeader"

class SquareMosaicObject {
    
    fileprivate enum SupplementaryKind {
        
        case backer, footer, header
        
        var value: String {
            switch self {
            case .backer:
                return SquareMosaicLayoutSectionBacker
            case .footer:
                return SquareMosaicLayoutSectionFooter
            case .header:
                return SquareMosaicLayoutSectionHeader
            }
        }
    }
    
    fileprivate var attributesForCells: [[UICollectionViewLayoutAttributes]]
    fileprivate var attributesForSupplementary = [UICollectionViewLayoutAttributes]()
    fileprivate var direction: SquareMosaicDirection = .vertical
    fileprivate var sectionFirstAdded: Int?
    fileprivate var size: CGSize = .zero
    fileprivate var total: CGFloat = 0.0
    
    init(_ numberOfItemsInSections: [Int], _ dataSource: SquareMosaicDataSource?, _ direction: SquareMosaicDirection, _ size: CGSize) {
        self.attributesForCells = Array<Array<UICollectionViewLayoutAttributes>>.init(repeating: [], count: numberOfItemsInSections.count)
        self.direction = direction
        self.size = size
        guard let dataSource = dataSource else { return }
        let sections = numberOfItemsInSections.count
        for section in 0 ..< sections {
            let rows: Int = numberOfItemsInSections[section]
            guard isEmptySection(dataSource: dataSource, rows: rows, section: section) == false else { continue }
            addSeparatorSection(dataSource, section: section, sections: sections)
            let sectionOffset: CGFloat = self.total
            addSupplementary(.header, dataSource: dataSource, rows: rows, section: section)
            let pattern: SquareMosaicPattern = dataSource.layoutPattern(for: section)
            addSeparatorBlock(.before, pattern: pattern, rows: rows)
            addAttributes(pattern, rows: rows, section: section)
            addSeparatorBlock(.after, pattern: pattern, rows: rows)
            addSupplementary(.footer, dataSource: dataSource, rows: rows, section: section)
            addSupplementaryBackground(.backer, dataSource: dataSource, offset: sectionOffset, section: section)
        }
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
        let attributes = attributesForCells.flatMap({ $0 }) + attributesForSupplementary
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
        let blocks: [SquareMosaicBlock] = patternBlocks()
        let framesCount: Int = blocks.map({$0.blockFrames()}).reduce(0, +)
        var layoutTypes = [SquareMosaicBlock]()
        var count: Int = 0
        repeat {
            layoutTypes.append(contentsOf: blocks)
            count += framesCount
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
            addSeparatorBlock(.between, block: index, blocks: blocks.count, pattern: pattern)
            let side = self.direction == .vertical ? self.size.width : self.size.height
            let frames = block.blockFrames(origin: self.total, side: side)
            var total: CGFloat = 0
            for x in 0..<block.blockFrames() {
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
        attributesForCells[section] = attributes
    }
    
    func addSeparatorBlock(_ position: SquareMosaicBlockSeparatorPosition, block: Int = 0, blocks: Int = 0, pattern: SquareMosaicPattern, rows: Int = 0) {
        switch (position, rows > 0, block > 0 && block < blocks) {
        case (.before, true, _):
            self.total += pattern.patternBlocksSeparator?(at: position) ?? 0
        case (.between, _, true):
            self.total += pattern.patternBlocksSeparator?(at: position) ?? 0
        case (.after, true, _):
            self.total += pattern.patternBlocksSeparator?(at: position) ?? 0
        default:
            break
        }
    }
    
    func addSeparatorSection(_ dataSource: SquareMosaicDataSource, section: Int, sections: Int) {
        if sectionFirstAdded == nil {
            sectionFirstAdded = section
        }
        guard sections > 0 else { return }
        let separator = dataSource.layoutSeparatorBetweenSections?() ?? 0
        guard section > sectionFirstAdded! && section < sections else { return }
        self.total += separator
    }
    
    func addSupplementary(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, rows: Int, section: Int) {
        guard let supplementary = getSupplementary(kind, dataSource: dataSource, section: section) else { return }
        guard rows > 0 || supplementary.supplementaryHiddenForEmptySection?() ?? false == false else { return }
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attributes.zIndex = 1
        switch self.direction {
        case .vertical:
            let frame = supplementary.supplementaryFrame(for: self.total, side: self.size.width)
            attributes.frame = frame
            self.total += (frame.origin.y + frame.height - self.total)
        case .horizontal:
            let frame = supplementary.supplementaryFrame(for: self.total, side: self.size.height)
            attributes.frame = frame
            self.total += (frame.origin.x + frame.width - self.total)
        }
        attributesForSupplementary.append(attributes)
    }
    
    func addSupplementaryBackground(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, offset: CGFloat, section: Int) {
        guard dataSource.layoutSupplementaryBackerRequired?(for: section) ?? false == true else { return }
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
    
    func getSupplementary(_ kind: SupplementaryKind, dataSource: SquareMosaicDataSource, section: Int) -> SquareMosaicSupplementary? {
        switch kind {
        case .footer:   return dataSource.layoutSupplementaryFooter?(for: section)
        case .header:   return dataSource.layoutSupplementaryHeader?(for: section)
        default:        return nil
        }
    }
    
    func isEmptySection(dataSource: SquareMosaicDataSource, rows: Int, section: Int) -> Bool {
        guard rows <= 0 else { return false }
        let dynamicHeader = dataSource.layoutSupplementaryHeader?(for: section)?.supplementaryHiddenForEmptySection?() ?? false
        guard dynamicHeader == true else { return false }
        let dynamicFooter = dataSource.layoutSupplementaryFooter?(for: section)?.supplementaryHiddenForEmptySection?() ?? false
        guard dynamicFooter == true else { return false }
        return true
    }
}
