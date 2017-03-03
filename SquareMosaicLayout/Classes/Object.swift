import Foundation

private extension SquareMosaicPattern {
    
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

public let SquareMosaicLayoutSectionBackground  = "SquareMosaicLayout.SquareMosaicLayoutSectionBackground"
public let SquareMosaicLayoutSectionFooter      = "SquareMosaicLayout.SquareMosaicLayoutSectionFooter"
public let SquareMosaicLayoutSectionHeader      = "SquareMosaicLayout.SquareMosaicLayoutSectionHeader"

class SquareMosaicObject {
    
    private enum SupplementaryKind {
        case background, footer, header
        var value: String {
            switch self {
            case .background:   return SquareMosaicLayoutSectionBackground
            case .footer:       return SquareMosaicLayoutSectionFooter
            case .header:       return SquareMosaicLayoutSectionHeader
            }
        }
    }
    
    fileprivate(set) lazy var cache = [[UICollectionViewLayoutAttributes]]()
    fileprivate(set) lazy var height: CGFloat  = 0.0
    fileprivate(set) lazy var supplementary = [UICollectionViewLayoutAttributes]()
    
    required init(capacity: [Int] = [Int](), dataSource: SquareMosaicDataSource? = nil, width: CGFloat = 0.0) {
        guard let dataSource = dataSource else { return }
        // add section top separator
        if capacity.count > 0, let separator = dataSource.separator?(.top) {
            self.height += separator
        }
        for section in 0..<capacity.count {
            // add section middle separator
            if section > 0 && section < capacity.count, let separator = dataSource.separator?(.middle) {
                self.height += separator
            }
            // start of decoration
            let decorationOffset: CGFloat = self.height
            // header
            if let header = dataSource.header?(section: section) {
                let indexPath = IndexPath(item: 0, section: section)
                let attributes = supplementary(header, height: &self.height, width: width, kind: .header, indexPath: indexPath)
                supplementary.append(attributes)
            }
            //
            let pattern = dataSource.pattern(section: section)
            var attributes = [UICollectionViewLayoutAttributes]()
            let rows = capacity[section]
            var row: Int = 0
            let blocks = pattern.blocks(rows)
            // add block top separator
            if rows > 0, let separator = pattern.separator?(.top) {
                self.height += separator
            }
            for (index, block) in blocks.enumerated() {
                guard row < rows else { break }
                // add block middle separator
                if index > 0 && index < blocks.count, let separator = pattern.separator?(.middle) {
                    self.height += separator
                }
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
            // add block bottom separator
            if rows > 0, let separator = pattern.separator?(.bottom) {
                self.height += separator
            }
            cache.append(attributes)
            // footer
            if let footer = dataSource.footer?(section: section) {
                let indexPath = IndexPath(item: 0, section: section)
                let attributes = supplementary(footer, height: &self.height, width: width, kind: .footer, indexPath: indexPath)
                supplementary.append(attributes)
            }
            // end of decoration
            let decorationHeight = self.height - decorationOffset
            let kind = SupplementaryKind.background.value
            let indexPath = IndexPath(item: 0, section: section)
            let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
            attribute.frame = CGRect(x: 0, y: decorationOffset, width: width, height: decorationHeight)
            attribute.zIndex = -1
            supplementary.append(attribute)
        }
        // add section bottom separator
        if capacity.count > 0, let separator = dataSource.separator?(.bottom) {
            self.height += separator
        }
    }
    
    private func supplementary(_ supplementary: SquareMosaicSupplementary, height: inout CGFloat, width: CGFloat, kind: SquareMosaicObject.SupplementaryKind, indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let frame = supplementary.frame(origin: height, width: width)
        let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attribute.frame = frame
        attribute.zIndex = 1
        let dy = attribute.frame.origin.y + attribute.frame.height - self.height
        height += dy
        return attribute
    }
}

extension SquareMosaicObject {
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < cache.count else { return  nil }
        guard indexPath.row < cache[indexPath.section].count else { return nil }
        return cache[indexPath.section][indexPath.row]
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let cache = self.cache.flatMap({$0}).filter({$0.frame.intersects(rect)})
        let supplementary = self.supplementary.filter({$0.frame.intersects(rect)})
        return cache + supplementary
    }
    
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return supplementary
            .filter({ $0.indexPath == indexPath })
            .filter({ $0.representedElementKind == elementKind })
            .first
    }
}
