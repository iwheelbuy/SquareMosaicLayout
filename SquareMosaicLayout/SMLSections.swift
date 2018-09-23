import Foundation

struct SMLSections {
    
    let direction: SMLDirection
    let sections: [SMLSection]
    
    init(dimension: SMLDimension, direction: SMLDirection, source: SMLSource) {
        self.direction = direction
        let sections = dimension.smlDimensionSections()
        switch sections {
        case 1...:
            var origin: CGFloat = 0
            let spacing = source.smlSourceSpacing()
            self.sections = Array<Int>(0 ..< sections)
                .compactMap({ SMLSection(dimension: dimension, direction: direction, section: $0, source: source) })
                .enumerated()
                .map({ (index, section) -> SMLSection in
                    if index > 0 {
                        origin += spacing
                    }
                    return section.updated(direction: direction, origin: &origin)
                })
        case 0:
            self.sections = []
        default:
            assertionFailure()
            self.sections = []
        }
    }
}

extension SMLSections: SMLAttributes, SMLContentSize {
    
    func smlContentSize() -> CGSize {
        switch sections.last {
        case .some(let section):
            let aspect = direction.smlDirectionAspect()
            let vertical = direction.smlDirectionVertical()
            switch vertical {
            case true:
                return CGSize(width: aspect, height: section.origin + section.length)
            case false:
                return CGSize(width: section.origin + section.length, height: aspect)
            }
        case .none:
            return .zero
        }
    }
    
    func smlAttributesForElement(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return sections.compactMap({ $0.smlAttributesForElement(rect: rect) }).flatMap({ $0 })
    }
    
    func smlAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sections.compactMap({ $0.smlAttributesForItem(indexPath: indexPath) }).first
    }
    
    func smlAttributesForSupplementary(elementKind: String, indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sections.compactMap({ $0.smlAttributesForSupplementary(elementKind: elementKind, indexPath: indexPath) }).first
    }
}

struct SMLSection {
    
    func updated(direction: SMLDirection, origin: inout CGFloat) -> SMLSection {
        let section = SMLSection(
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
    
    struct Item {
        
        let frame: CGRect
        let index: Int
        
        func updated(direction: SMLDirection, origin: CGFloat) -> Item {
            var frame = self.frame
            let vertical = direction.smlDirectionVertical()
            switch vertical {
            case true:
                frame.origin.y = origin + frame.origin.y
            case false:
                frame.origin.x = origin + frame.origin.x
            }
            return Item(frame: frame, index: index)
        }
    }
    
    static func makeSpacing(blockCurrentIndex: Int, blocksTotalCount: Int, pattern: SMLPattern, position: SMLPosition) -> CGFloat {
        assert(blockCurrentIndex < blocksTotalCount)
        let first = blockCurrentIndex == 0
        let last = blockCurrentIndex + 1 == blocksTotalCount
        switch (position, first, last) {
        case (.after, false, true):
            return pattern.smlPatternSpacing(position: position)
        case (.before, true, false):
            return pattern.smlPatternSpacing(position: position)
        case (.between, false, false):
            return pattern.smlPatternSpacing(position: position)
        default:
            return 0
        }
    }
    
    struct Supplementary {
        
        let frame: CGRect
        let kind: String
        let zIndex: Int
        
        func updated(direction: SMLDirection, origin: CGFloat) -> Supplementary {
            var frame = self.frame
            let vertical = direction.smlDirectionVertical()
            switch vertical {
            case true:
                frame.origin.y = origin + frame.origin.y
            case false:
                frame.origin.x = origin + frame.origin.x
            }
            return Supplementary(frame: frame, kind: kind, zIndex: zIndex)
        }
    }
    
    var backer: Supplementary?
    var footer: Supplementary?
    var header: Supplementary?
    let index: Int
    var items: [Item]
    let length: CGFloat
    let origin: CGFloat
    
    init(backer: Supplementary?, footer: Supplementary?, header: Supplementary?, index: Int, items: [Item], length: CGFloat, origin: CGFloat) {
        self.backer = backer
        self.footer = footer
        self.header = header
        self.index = index
        self.items = items
        self.length = length
        self.origin = origin
    }
    
    static func makeBacker(direction: SMLDirection, kind: String, origin: CGFloat) -> Supplementary {
        let aspect = direction.smlDirectionAspect()
        let frame: CGRect
        let vertical = direction.smlDirectionVertical()
        switch vertical {
        case true:
            frame = CGRect(origin: .zero, size: CGSize(width: aspect, height: origin))
        case false:
            frame = CGRect(origin: .zero, size: CGSize(width: origin, height: aspect))
        }
        return Supplementary(frame: frame, kind: kind, zIndex: -1)
    }
    
    static func makeItems(direction: SMLDirection, origin: inout CGFloat, pattern: SMLPattern, rows: Int, section: Int) -> [Item] {
        let aspect = direction.smlDirectionAspect()
        let blocks = pattern.smlPatternBlocks(rows: rows)
        let blocksTotalCount = blocks.count
        var frames = [CGRect]()
        let vertical = direction.smlDirectionVertical()
        for (blockCurrentIndex, block) in blocks.enumerated() {
            let row = frames.count
            guard row < rows else {
                break
            }
            origin += makeSpacing(blockCurrentIndex: blockCurrentIndex, blocksTotalCount: blocksTotalCount, pattern: pattern, position: .before)
            origin += makeSpacing(blockCurrentIndex: blockCurrentIndex, blocksTotalCount: blocksTotalCount, pattern: pattern, position: .between)
            let array = block
                .smlBlockFrames(aspect: aspect, origin: origin)
                .prefix(rows - row)
                .array
            switch vertical {
            case true:
                origin += array.map({ $0.origin.y - origin + $0.size.height }).max() ?? 0
            case false:
                origin += array.map({ $0.origin.x - origin + $0.size.width }).max() ?? 0
            }
            frames += array
            origin += makeSpacing(blockCurrentIndex: blockCurrentIndex, blocksTotalCount: blocksTotalCount, pattern: pattern, position: .after)
        }
        return frames.enumerated().map({ Item(frame: $0.element, index: $0.offset) })
    }
    
    static func makeSupplementary(direction: SMLDirection, origin: inout CGFloat, supplementary: SMLSupplementary?) -> Supplementary? {
        guard let supplementary = supplementary else {
            return nil
        }
        let aspect = direction.smlDirectionAspect()
        let frame = supplementary.smlSupplementaryFrame(aspect: aspect, origin: origin)
        let kind = supplementary.smlSupplementaryKind()
        let vertical = direction.smlDirectionVertical()
        switch vertical {
        case true:
            origin += frame.origin.y - origin + frame.size.height
        case false:
            origin += frame.origin.x - origin + frame.size.width
        }
        return Supplementary(frame: frame, kind: kind, zIndex: 1)
    }
    
    init?(dimension: SMLDimension, direction: SMLDirection, section: Int, source: SMLSource) {
        self.index = section
        let rows = dimension.smlDimensionRows(section: section)
        let supplementaries = [source.smlSourceHeader(section: section), source.smlSourceFooter(section: section)]
        switch rows {
        case 0:
            switch supplementaries.contains(where: { $0?.smlSupplementaryIsHiddenForEmptySection() == false }) {
            case false:
                return nil
            case true:
                var origin: CGFloat = 0
                self.origin = origin
                self.header = SMLSection.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[0])
                self.items = []
                self.footer = SMLSection.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[1])
                self.backer = {
                    guard supplementaries.contains(where: { $0 != nil }), let kind = source.smlSourceBacker(section: section) else {
                        return nil
                    }
                    return SMLSection.makeBacker(direction: direction, kind: kind, origin: origin)
                }()
                self.length = origin
            }
        case 1...:
            var origin: CGFloat = 0
            let pattern = source.smlSourcePattern(section: section)
            self.origin = origin
            self.header = SMLSection.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[0])
            self.items = SMLSection.makeItems(direction: direction, origin: &origin, pattern: pattern, rows: rows, section: section)
            self.footer = SMLSection.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[1])
            self.backer = {
                guard let kind = source.smlSourceBacker(section: section) else {
                    return nil
                }
                return SMLSection.makeBacker(direction: direction, kind: kind, origin: origin)
            }()
            self.length = origin
        default:
            assertionFailure()
            return nil
        }
    }
}

extension SMLSection: SMLAttributes {
    
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
}

private extension ArraySlice {
    
    var array: Array<Element> {
        return Array(self)
    }
}

extension Array where Element == SMLSection.Item {
    
    func updated(direction: SMLDirection, origin: CGFloat) -> [SMLSection.Item] {
        return map({ $0.updated(direction: direction, origin: origin) })
    }
}
