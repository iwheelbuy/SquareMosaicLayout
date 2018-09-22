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

fileprivate struct Attributes {
    
    let cell: [[UICollectionViewLayoutAttributes]]
    let supplementary: [UICollectionViewLayoutAttributes]
}

final class SquareMosaicObject {
    
    fileprivate let attributes: Attributes
    let contentSize: CGFloat
    
    init?(dimension: SMLDimension, source: SMLSource?, direction: SMLDirection) {
        guard let source = source else {
            return nil
        }
        let attributesAndContentSize = getAttributesAndContentSize(numberOfItemsInSections: dimension.numberOfItemsInSections, source: source, direction: direction)
        attributes = attributesAndContentSize.attributes
        contentSize = attributesAndContentSize.contentSize
    }
}

// MARK: -

extension SquareMosaicObject {
    
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

// MARK: - Internal

private extension SMLPattern {
    
    func blocks(_ expectedFrames: Int) -> [SMLBlock] {
        let blocks: [SMLBlock] = smlPatternBlocks()
        let blocksNoRepeat = blocks.prefix(while: { $0.smlBlockRepeated() == false })
        let blocksNoRepeatFrames = blocksNoRepeat.map({ $0.smlBlockCapacity() }).reduce(0, +)
        switch blocksNoRepeat.indices.count < blocks.count {
        case true:
            guard blocksNoRepeatFrames < expectedFrames else {
                return Array(blocksNoRepeat)
            }
            let blockToRepeat = blocks[blocksNoRepeat.endIndex]
            let blockToRepeatFrames = blockToRepeat.smlBlockCapacity()
            let blockToRepeatRange = 0 ... (expectedFrames - blocksNoRepeatFrames) / blockToRepeatFrames
            return Array(blocksNoRepeat) + Array(blockToRepeatRange).map({ _ in blockToRepeat })
        case false:
            let blocksNoRepeatRange = 0 ... expectedFrames / blocksNoRepeatFrames
            return Array<Int>(blocksNoRepeatRange).map({ _ in Array(blocksNoRepeat) }).flatMap({ $0 })
        }
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
        let pattern: SMLPattern = source.layoutPattern(for: section)
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
    let blocks = pattern.blocks(rows)
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
        guard source.layoutSupplementaryBackerRequired(for: section) == true else {
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
    } else if source.layoutSupplementaryHeader(for: section)?.smlSupplementaryIsHiddenForEmptySection() == false {
        return true
    } else if source.layoutSupplementaryFooter(for: section)?.smlSupplementaryIsHiddenForEmptySection() == false {
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
        let separator = source.layoutSeparatorBetweenSections()
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
        return source.layoutSupplementaryFooter(for: section)
    case .header:
        return source.layoutSupplementaryHeader(for: section)
    default:
        return nil
    }
}
