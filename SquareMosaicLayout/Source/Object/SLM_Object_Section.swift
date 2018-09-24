import Foundation

struct SMLObjectSection {
    
    var backer: SMLObjectSupplementary?
    var footer: SMLObjectSupplementary?
    var header: SMLObjectSupplementary?
    let index: Int
    var items: [SMLObjectItem]
    let length: CGFloat
    let origin: CGFloat
    
    init(backer: SMLObjectSupplementary?, footer: SMLObjectSupplementary?, header: SMLObjectSupplementary?, index: Int, items: [SMLObjectItem], length: CGFloat, origin: CGFloat) {
        self.backer = backer
        self.footer = footer
        self.header = header
        self.index = index
        self.items = items
        self.length = length
        self.origin = origin
    }
    
    func updated(visible: SMLVisible) -> SMLObjectSection {
        guard smlAttributesInvalidationRequired(visible: visible) else {
            return self
        }
        guard let header = self.header?.updated(direction: SMLObjectDirection(aspect: 0, vertical: true), origin: visible.origin) else {
            return self
        }
        return SMLObjectSection(backer: backer, footer: footer, header: header, index: index, items: items, length: length, origin: origin)
    }
    
    func updated(direction: SMLObjectDirection, origin: inout CGFloat) -> SMLObjectSection {
        let section = SMLObjectSection(
            backer: backer?.updated(direction: direction, origin: origin),
            footer: footer?.updated(direction: direction, origin: origin),
            header: header?.updated(direction: direction, origin: origin),
            index: index,
            items: items.updated(direction: direction, origin: origin),
            length: length,
            origin: self.origin + origin
        )
        origin = origin + length
        return section
    }
    
    static func makeItems(direction: SMLObjectDirection, origin: inout CGFloat, pattern: SMLPattern, rows: Int, section: Int) -> [SMLObjectItem] {
        let aspect = direction.aspect
        let blocks = SMLObjectBlockArray(pattern: pattern, rows: rows).blocks
        let total = blocks.count
        var frames = ArraySlice<CGRect>()
        let vertical = direction.vertical
        for (current, block) in blocks.enumerated() {
            let row = frames.count
            guard row < rows else {
                break
            }
            origin += SMLObjectSpacing(current: current, pattern: pattern, position: .before, total: total)?.value ?? 0
            origin += SMLObjectSpacing(current: current, pattern: pattern, position: .between, total: total)?.value ?? 0
            let slice = block.smlBlockFrames(aspect: aspect, origin: origin).prefix(rows - row)
            switch vertical {
            case true:
                origin += slice.map({ $0.origin.y - origin + $0.size.height }).max() ?? 0
            case false:
                origin += slice.map({ $0.origin.x - origin + $0.size.width }).max() ?? 0
            }
            frames += slice
            origin += SMLObjectSpacing(current: current, pattern: pattern, position: .after, total: total)?.value ?? 0
        }
        return frames.enumerated().map({ SMLObjectItem(frame: $0.element, index: $0.offset) })
    }
    
    init?(dimension: SMLDimension, direction: SMLObjectDirection, section: Int, source: SMLSource) {
        self.index = section
        let rows = dimension[section]
        let supplementaries = [source.smlSourceHeader(section: section), source.smlSourceFooter(section: section)]
        switch rows {
        case 0:
            switch supplementaries.contains(where: { $0?.smlSupplementaryIsHiddenForEmptySection() == false }) {
            case false:
                return nil
            case true:
                var origin: CGFloat = 0
                self.origin = origin
                self.header = SMLObjectSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[0], zIndex: 1)
                self.items = []
                self.footer = SMLObjectSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[1], zIndex: 1)
                self.backer = {
                    guard supplementaries.contains(where: { $0 != nil }), let kind = source.smlSourceBacker(section: section) else {
                        return nil
                    }
                    return SMLObjectSupplementary(direction: direction, kind: kind, length: origin, zIndex: -1)
                }()
                self.length = origin
            }
        case 1...:
            var origin: CGFloat = 0
            let pattern = source.smlSourcePattern(section: section)
            self.origin = origin
            self.header = SMLObjectSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[0], zIndex: 1)
            self.items = SMLObjectSection.makeItems(direction: direction, origin: &origin, pattern: pattern, rows: rows, section: section)
            self.footer = SMLObjectSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[1], zIndex: 1)
            self.backer = {
                guard let kind = source.smlSourceBacker(section: section) else {
                    return nil
                }
                return SMLObjectSupplementary(direction: direction, kind: kind, length: origin, zIndex: -1)
            }()
            self.length = origin
        default:
            assertionFailure()
            return nil
        }
    }
}

extension SMLObjectSection {
    
    func smlAttributesForElement(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let section = self.index
        let items = self.items
            .filter({ $0.frame.intersects(rect) })
            .map({ (item) -> UICollectionViewLayoutAttributes in
                let row = item.index
                let indexPath = IndexPath(row: row, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = item.frame
                attributes.zIndex = 0
                return attributes
            })
        let supplementary = [backer, footer, header]
            .compactMap({ $0 })
            .filter({ $0.frame.intersects(rect) })
            .map({ (supplementary) -> UICollectionViewLayoutAttributes in
                let elementKind = supplementary.kind
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
                attributes.frame = supplementary.frame
                attributes.zIndex = supplementary.zIndex
                return attributes
            })
        return items + supplementary
    }
    
    func smlAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section == self.index else {
            return nil
        }
        guard let item = items.first(where: { $0.index == indexPath.row }) else {
            return nil
        }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = item.frame
        attributes.zIndex = 0
        return attributes
    }
    
    func smlAttributesForSupplementary(elementKind: String, indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section == self.index else {
            return nil
        }
        guard let supplementary = [backer, footer, header].compactMap({ $0 }).first(where: { $0?.kind == elementKind }) else {
            return nil
        }
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.frame = supplementary.frame
        attributes.zIndex = supplementary.zIndex
        return attributes
    }
    
    func smlAttributesInvalidationRequired(visible: SMLVisible) -> Bool {
        let range = origin ... origin + length
        print(range, visible.range)
        return range.overlaps(visible.range)
    }
}
