import Foundation

public let SquareMosaicLayoutSectionBacker = "SquareMosaicLayout.SquareMosaicLayoutSectionBacker"
public let SquareMosaicLayoutSectionFooter = "SquareMosaicLayout.SquareMosaicLayoutSectionFooter"
public let SquareMosaicLayoutSectionHeader = "SquareMosaicLayout.SquareMosaicLayoutSectionHeader"

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

fileprivate enum SectionsNonEmpty {
    
    case none
    case multiple([Int])
    case single(Int)
}

struct Attributes {
    
    let cell: [[UICollectionViewLayoutAttributes]]
    let supplementary: [UICollectionViewLayoutAttributes]
}

final class SMLObject {
    
    fileprivate let attributes: Attributes
    let contentSize: CGFloat
    
    init(dimension: SMLDimension, direction: SMLDirection, source: SMLSource) {
        
        let attributesAndContentSize = getAttributesAndContentSize(numberOfItemsInSections: dimension.numberOfItemsInSections, source: source, direction: direction)
        attributes = attributesAndContentSize.attributes
        contentSize = attributesAndContentSize.contentSize
    }
}

extension ArraySlice {
    
    var array: Array<Element> {
        return Array(self)
    }
}

extension SMLObject {
    
    static func makeSections(dimension: SMLDimension, direction: SMLDirection, source: SMLSource) -> [Section]? {
        let sections = dimension.smlDimensionSections()
        guard sections > 0 else {
            return nil
        }
        return Array(0 ..< sections)
            .compactMap({ Section(dimension: dimension, direction: direction, section: $0, source: source) })
    }
    
    static func makeAttributes(dimension: SMLDimension, direction: SMLDirection, source: SMLSource) -> Attributes {
        guard let sections = makeSections(dimension: dimension, direction: direction, source: source), sections.count > 0 else {
            return Attributes(cell: [], supplementary: [])
        }
        var origin: CGFloat = 0
        
        typealias Nice = (cells: [UICollectionViewLayoutAttributes], supplementary: [UICollectionViewLayoutAttributes])
        sections
            .reduce(into: Nice([],[])) { (nice, section) in
                <#code#>
            }
        var attributes = sections
            .map({ (section: Section) -> (cells: [UICollectionViewLayoutAttributes], supplementary: [UICollectionViewLayoutAttributes]) in
                guard section.frames.count > 0 else {
                    return [UICollectionViewLayoutAttributes]()
                }
                let cells = section
                    .frames
                    .enumerated()
                    .map({ [section = section.index] (row, frame) -> UICollectionViewLayoutAttributes in
                        let indexPath = IndexPath(row: row, section: section)
                        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                        attributes.frame = frame
                        attributes.zIndex = 0
                        return attributes
                    })
                let supplementary = [(1, SquareMosaicLayoutSectionHeader, section.header), (1, SquareMosaicLayoutSectionFooter section.footer), (-1, SquareMosaicLayoutSectionBacker, section.backer)]
                    .compactMap({ [section = section.index] (zIndex, kind, frame) -> UICollectionViewLayoutAttributes? in
                        guard let frame = frame else {
                            return nil
                        }
                        let indexPath = IndexPath(row: 0, section: section)
                        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
                        attributes.frame = frame
                        attributes.zIndex = zIndex
                    })
                return (cells, supplementary)
            })
    }
    
    struct Section {
        
        struct Item {
            
            let frame: CGRect
            let indexPath: IndexPath
        }
        
        struct Spacing {
            
            let value: CGFloat
            
            init(blockCurrentIndex: Int, blocksTotalCount: Int, pattern: SMLPattern, position: SMLPosition) {
                assert(blockCurrentIndex < blocksTotalCount)
                let first = blockCurrentIndex == 0
                let last = blockCurrentIndex + 1 == blocksTotalCount
                switch (position, first, last) {
                case (.after, false, true):
                    self.value = pattern.smlPatternSpacing(position: position)
                case (.before, true, false):
                    self.value = pattern.smlPatternSpacing(position: position)
                case (.between, false, false):
                    self.value = pattern.smlPatternSpacing(position: position)
                default:
                    self.value = 0
                }
            }
        }
        
        let backer: CGRect?
        let footer: CGRect?
        let frames: [CGRect]
        let header: CGRect?
        let index: Int
        
        static func makeBacker(direction: SMLDirection, origin: CGFloat) -> CGRect {
            let aspect = direction.smlDirectionAspect()
            let vertical = direction.smlDirectionVertical()
            switch vertical {
            case true:
                return CGRect(origin: CGPoint(x: 0, y: origin), size: CGSize(width: aspect, height: origin))
            case false:
                return CGRect(origin: CGPoint(x: origin, y: 0), size: CGSize(width: origin, height: aspect))
            }
        }
        
        static func makeFrames(direction: SMLDirection, origin: inout CGFloat, pattern: SMLPattern, rows: Int, section: Int) -> [CGRect] {
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
                origin += Spacing(blockCurrentIndex: blockCurrentIndex, blocksTotalCount: blocksTotalCount, pattern: pattern, position: .before).value
                origin += Spacing(blockCurrentIndex: blockCurrentIndex, blocksTotalCount: blocksTotalCount, pattern: pattern, position: .between).value
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
                origin += Spacing(blockCurrentIndex: blockCurrentIndex, blocksTotalCount: blocksTotalCount, pattern: pattern, position: .after).value
            }
            return frames
        }
        
        static func makeSupplementary(direction: SMLDirection, origin: inout CGFloat, supplementary: SMLSupplementary?) -> CGRect? {
            guard let supplementary = supplementary else {
                return nil
            }
            let aspect = direction.smlDirectionAspect()
            let frame = supplementary.smlSupplementaryFrame(aspect: aspect, origin: origin)
            let vertical = direction.smlDirectionVertical()
            switch vertical {
            case true:
                origin += frame.origin.y - origin + frame.size.height
            case false:
                origin += frame.origin.x - origin + frame.size.width
            }
            return frame
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
                    self.header = SMLObject.Section.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[0])
                    self.frames = []
                    self.footer = SMLObject.Section.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[1])
                    self.backer = source.smlSourceBacker(section: section) && supplementaries.contains(where: { $0 != nil }) ? SMLObject.Section.makeBacker(direction: direction, origin: origin) : nil
                }
            case 1...:
                var origin: CGFloat = 0
                let pattern = source.smlSourcePattern(section: section)
                self.header = SMLObject.Section.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[0])
                self.frames = SMLObject.Section.makeFrames(direction: direction, origin: &origin, pattern: pattern, rows: rows, section: section)
                self.footer = SMLObject.Section.makeSupplementary(direction: direction, origin: &origin, supplementary: supplementaries[1])
                self.backer = source.smlSourceBacker(section: section) ? SMLObject.Section.makeBacker(direction: direction, origin: origin) : nil
            default:
                assertionFailure()
                return nil
            }
        }
    }
}

// MARK: -

extension SMLObject {
    
    func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section < attributes.cell.count else { return  nil }
        guard indexPath.row < attributes.cell[indexPath.section].count else { return nil }
        return attributes.cell[indexPath.section][indexPath.row]
    }
    
    func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.cell.flatMap({ $0 }).filter({ $0.frame.intersects(rect) }) + attributes.supplementary.filter({ $0.frame.intersects(rect) })
    }
    
    func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributes.supplementary.first(where: { $0.indexPath == indexPath && $0.representedElementKind == elementKind })
    }
}

// MARK: -

private func getAttributesAndContentSize(numberOfItemsInSections: [Int], source: SMLSource, direction: SMLDirection) -> (attributes: Attributes, contentSize: CGFloat) {
    var attributesCell = [[UICollectionViewLayoutAttributes]](repeating: [], count: numberOfItemsInSections.count)
    var attributesSupplementary = [UICollectionViewLayoutAttributes]()
    var origin: CGFloat = 0
    let sectionsNonEmpty = getSectionsNonEmpty(source: source, numberOfItemsInSections: numberOfItemsInSections)
    for (rows, section) in Array(0 ..< numberOfItemsInSections.count).map({ (numberOfItemsInSections[$0], $0) }) {
        if let separator = getSeparatorBeforeSection(source: source, section: section, sectionsNonEmpty: sectionsNonEmpty) {
            origin += separator
        }
        let sectionOrigin = origin
        if let (attributes, separator) = getAttributesSupplementary(.header, source: source, direction: direction, origin, rows: rows, section) {
            if let separator = separator {
                origin += separator
            }
            attributesSupplementary.append(attributes)
        }
        let pattern: SMLPattern = source.smlSourcePattern(section: section)
        if let separator = getSeparatorBlock(.before, pattern: pattern, rows: rows) {
            origin += separator
        }
        if let (attributes, separator) = getAttributesCells(pattern, direction: direction, origin, rows, section) {
            if let separator = separator {
                origin += separator
            }
            attributesCell[section] = attributes
        }
        if let separator = getSeparatorBlock(.after, pattern: pattern, rows: rows) {
            origin += separator
        }
        if let (attributes, separator) = getAttributesSupplementary(.footer, source: source, direction: direction, origin, rows: rows, section) {
            if let separator = separator {
                origin += separator
            }
            attributesSupplementary.append(attributes)
        }
        if let (attributes, _) = getAttributesSupplementary(.backer, source: source, direction: direction, origin, section, sectionOrigin: sectionOrigin) {
            attributesSupplementary.append(attributes)
        }
    }
    return (Attributes(cell: attributesCell, supplementary: attributesSupplementary), origin)
}

private func getAttributesCells(_ pattern: SMLPattern, direction: SMLDirection, _ origin: CGFloat, _ rows: Int, _ section: Int) -> (attributes: [UICollectionViewLayoutAttributes], separator: CGFloat?)? {
    var append: CGFloat = 0
    var attributes = [UICollectionViewLayoutAttributes]()
    var origin = origin
    var row: Int = 0
    let blocks = pattern.smlPatternBlocks(rows: rows)
    for (index, block) in blocks.enumerated() {
        guard row < rows else {
            break
        }
        if let separator = getSeparatorBlock(.between, blocks: blocks.count, index: index, pattern: pattern) {
            append += separator
            origin += separator
        }
        let aspect = direction.smlDirectionAspect()
        let frames = block.smlBlockFrames(aspect: aspect, origin: origin)
        var total: CGFloat = 0
        for x in 0 ..< block.smlBlockCapacity() {
            guard row < rows else { break }
            let indexPath = IndexPath(row: row, section: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attribute.frame = frames[x]
            attribute.zIndex = 0
            switch direction.smlDirectionVertical() {
            case true:
                let dy = attribute.frame.origin.y + attribute.frame.height - origin
                total = dy > total ? dy : total
            case false:
                let dx = attribute.frame.origin.x + attribute.frame.width - origin
                total = dx > total ? dx : total
            }
            attributes.append(attribute)
            row += 1
        }
        append += total
        origin += total
    }
    if attributes.count > 0 {
        return (attributes, append > 0 ? append : nil)
    } else {
        return nil
    }
}

private func getAttributesSupplementary(_ kind: SupplementaryKind, source: SMLSource, direction: SMLDirection, _ origin: CGFloat, rows: Int = 0, _ section: Int, sectionOrigin: CGFloat = 0) -> (attributes: UICollectionViewLayoutAttributes, separator: CGFloat?)? {
    switch kind {
    case .backer:
        guard source.smlSourceBacker(section: section) == true else {
            return nil
        }
        let side = origin - sectionOrigin
        guard side > 0 else {
            return nil
        }
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        attributes.zIndex = -1
        switch direction.smlDirectionVertical() {
        case true:
            attributes.frame = CGRect(
                origin: CGPoint(x: 0.0, y: sectionOrigin),
                size: CGSize(width: direction.smlDirectionAspect(), height: side)
            )
        case false:
            attributes.frame = CGRect(
                origin: CGPoint(x: sectionOrigin, y: 0.0),
                size: CGSize(width: side, height: direction.smlDirectionAspect())
            )
        }
        return (attributes, nil)
    default:
        guard let supplementary = getSupplementary(kind, source: source, section: section) else {
            return nil
        }
        guard rows > 0 || supplementary.smlSupplementaryIsHiddenForEmptySection() == false else {
            return nil
        }
        let aspect = direction.smlDirectionAspect()
        let indexPath = IndexPath(item: 0, section: section)
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind.value, with: indexPath)
        var separator: CGFloat
        attributes.zIndex = 1
        switch direction.smlDirectionVertical() {
        case true:
            attributes.frame = supplementary.smlSupplementaryFrame(aspect: aspect, origin: origin)
            separator =  attributes.frame.origin.y + attributes.frame.height - origin
        case false:
            attributes.frame = supplementary.smlSupplementaryFrame(aspect: aspect, origin: origin)
            separator =  attributes.frame.origin.x + attributes.frame.width - origin
        }
        return (attributes, separator)
    }
}

private func getSectionNonEmpty(source: SMLSource, _ rows: Int, _ section: Int) -> Bool {
    if rows > 0 {
        return true
    } else if source.smlSourceHeader(section: section)?.smlSupplementaryIsHiddenForEmptySection() == false {
        return true
    } else if source.smlSourceFooter(section: section)?.smlSupplementaryIsHiddenForEmptySection() == false {
        return true
    } else {
        return false
    }
}

private func getSectionsNonEmpty(source: SMLSource, numberOfItemsInSections: [Int]) -> SectionsNonEmpty {
    let sectionsNonEmpty = numberOfItemsInSections
        .enumerated()
        .map({ (rows: $0.element, section: $0.offset) })
        .filter({ object -> Bool in
            return getSectionNonEmpty(source: source, object.rows, object.section)
        })
    switch sectionsNonEmpty.count {
    case 2...:
        let sections = sectionsNonEmpty.map({ $0.section })
        return SectionsNonEmpty.multiple(sections)
    case 1:
        let section = sectionsNonEmpty[0].section
        return SectionsNonEmpty.single(section)
    default:
        return SectionsNonEmpty.none
    }
}

private func getSeparatorBeforeSection(source: SMLSource, section: Int, sectionsNonEmpty: SectionsNonEmpty) -> CGFloat? {
    switch sectionsNonEmpty {
    case .multiple(let sections):
        let separator = source.smlSourceSpacing()
        switch separator {
        case ...0:
            return nil
        default:
            switch sections.dropFirst().contains(section) {
            case true:
                return separator
            case false:
                return nil
            }
        }
    default:
        return nil
    }
}

private func getSeparatorBlock(_ position: SMLPosition, blocks: Int = 0, index: Int = 0, pattern: SMLPattern, rows: Int = 0) -> CGFloat? {
    switch (position, rows > 0, index > 0 && index < blocks) {
    case (.before, true, _), (.between, _, true), (.after, true, _):
        return pattern.smlPatternSpacing(position: position)
    default:
        return nil
    }
}

private func getSupplementary(_ kind: SupplementaryKind, source: SMLSource, section: Int) -> SMLSupplementary? {
    switch kind {
    case .footer:
        return source.smlSourceFooter(section: section)
    case .header:
        return source.smlSourceHeader(section: section)
    default:
        return nil
    }
}
