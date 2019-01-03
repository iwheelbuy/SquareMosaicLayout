import UIKit

final class SMLayoutObjectSection {
    
    var backer: SMLayoutObjectSupplementary?
    var footer: SMLayoutObjectSupplementary?
    var header: SMLayoutObjectSupplementary?
    let index: Int
    private(set) var items: [SMLayoutObjectItem]
    let length: CGFloat
    private(set) var origin: CGFloat
    var visible: SMLayoutVisible?
    
    private init(backer: SMLayoutObjectSupplementary?, footer: SMLayoutObjectSupplementary?, header: SMLayoutObjectSupplementary?, index: Int, items: [SMLayoutObjectItem], length: CGFloat, origin: CGFloat) {
        self.backer = backer
        self.footer = footer
        self.header = header
        self.index = index
        self.items = items
        self.length = length
        self.origin = origin
    }
    
    convenience init(aspect: CGFloat, direction: SMLayoutDirection, rows: Int, section: Int, source: SMLayoutSource) {
        let index = section
        var origin: CGFloat = 0
        let pattern = source.smLayoutSourcePattern(section: section)
        var header = SMLayoutObjectSupplementary(
            aspect: aspect,
            direction: direction,
            origin: &origin,
            stick: source.smLayoutSourceHeader(section: section)?.smLayoutSupplementarySticky() ?? false ? .top : nil,
            supplementary: source.smLayoutSourceHeader(section: section),
            zIndex: 1
        )
        let items = Array<SMLayoutObjectItem>(
            aspect: aspect,
            direction: direction,
            origin: &origin,
            pattern: pattern,
            rows: rows,
            section: section
        )
        var footer = SMLayoutObjectSupplementary(
            aspect: aspect,
            direction: direction,
            origin: &origin,
            stick: source.smLayoutSourceFooter(section: section)?.smLayoutSupplementarySticky() ?? false ? .bottom : nil,
            supplementary: source.smLayoutSourceFooter(section: section),
            zIndex: 1
        )
        let backer: SMLayoutObjectSupplementary? = {
            guard let kind = source.smLayoutSourceBacker(section: section) else {
                return nil
            }
            return SMLayoutObjectSupplementary(aspect: aspect, direction: direction, kind: kind, length: origin, zIndex: -1)
        }()
        let length = origin
        if let frameHeader = header?.frameInitial {
            switch footer?.frameInitial {
            case .some(let frameFooter):
                switch direction {
                case .horizontal:
                    header?.rangeInitial = frameHeader.origin.x ... frameFooter.origin.x - frameHeader.size.width
                case .vertical:
                    header?.rangeInitial = frameHeader.origin.y ... frameFooter.origin.y - frameHeader.size.height
                }
            case .none:
                switch direction {
                case .horizontal:
                    header?.rangeInitial = frameHeader.origin.x ... length - frameHeader.size.width
                case .vertical:
                    header?.rangeInitial = frameHeader.origin.y ... length - frameHeader.size.height
                }
            }
        }
        if let frameFooter = footer?.frameInitial {
            switch header?.frameInitial {
            case .some(let frameHeader):
                switch direction {
                case .horizontal:
                    footer?.rangeInitial = frameHeader.origin.x + frameHeader.size.width ... frameFooter.origin.x
                case .vertical:
                    footer?.rangeInitial = frameHeader.origin.y + frameHeader.size.height ... frameFooter.origin.y
                }
            case .none:
                switch direction {
                case .horizontal:
                    footer?.rangeInitial = 0 ... length - frameFooter.size.width
                case .vertical:
                    footer?.rangeInitial = 0 ... length - frameFooter.size.height
                }
            }
        }
        self.init(backer: backer, footer: footer, header: header, index: index, items: items, length: length, origin: 0)
    }
}

extension SMLayoutObjectSection {
    
    func smLayoutAttributesForElement(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
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
            .filter({ $0.frameCurrent.intersects(rect) })
            .map({ (supplementary) -> UICollectionViewLayoutAttributes in
                let elementKind = supplementary.kind
                let indexPath = IndexPath(row: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
                attributes.frame = supplementary.frameCurrent
                attributes.zIndex = supplementary.zIndex
                return attributes
            })
        return items + supplementary
    }
    
    func smLayoutAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
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
    
    func smLayoutAttributesForSupplementary(elementKind: String, indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard indexPath.section == self.index else {
            return nil
        }
        guard let supplementary = [backer, footer, header].compactMap({ $0 }).first(where: { $0?.kind == elementKind }) else {
            return nil
        }
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.frame = supplementary.frameCurrent
        attributes.zIndex = supplementary.zIndex
        return attributes
    }
    
    func smLayoutAttributesInvalidationRequired(visible: SMLayoutVisible?) -> Bool {
        guard let visible = visible else {
            return false
        }
        let range = origin ... origin + length
        let invalidationRequired = range.overlaps(visible.range)
        return invalidationRequired
    }
}

extension SMLayoutObjectSection {
    
    func smLayoutUpdated(direction: SMLayoutDirection, origin: SMLayoutOrigin) {
        self.backer?.smLayoutUpdated(direction: direction, origin: origin)
        self.footer?.smLayoutUpdated(direction: direction, origin: origin)
        self.header?.smLayoutUpdated(direction: direction, origin: origin)
        self.items.forEach({ $0.smLayoutUpdated(direction: direction, origin: origin) })
        self.origin = self.origin + origin.value
    }
    
    func smLayoutUpdated(visible: SMLayoutVisible) {
        self.footer?.smLayoutUpdated(visible: visible)
        self.header?.smLayoutUpdated(visible: visible)
        self.items.forEach({ $0.smLayoutUpdated(visible: visible) })
    }
    
    func smLayoutUpdateRequired(visible: SMLayoutVisible) -> Bool {
        for supplementary in [self.header, self.footer].compactMap({ $0 }) {
            if supplementary.smLayoutUpdateRequired(visible: visible) {
                return true
            }
        }
        return false
    }
}

extension Array where Element == SMLayoutObjectItem {
    
    init(aspect: CGFloat, direction: SMLayoutDirection, origin: inout CGFloat, pattern: SMLayoutPattern, rows: Int, section: Int) {
        let blocks = Array<SMLayoutBlockWrapper>.init(pattern: pattern, rows: rows)
        var frames = ArraySlice<CGRect>()
        var previous: SMLayoutBlock?
        for block in blocks {
            let row = frames.count
            guard row < rows else {
                break
            }
            if let previous = previous {
                origin += pattern.smLayoutPatternSpacing(previous: previous, current: block)
            }
            let slice = block.smLayoutBlockFrames(aspect: aspect, origin: origin).prefix(rows - row)
            switch direction {
            case .vertical:
                origin += slice.map({ $0.origin.y - origin + $0.size.height }).max() ?? 0
            case .horizontal:
                origin += slice.map({ $0.origin.x - origin + $0.size.width }).max() ?? 0
            }
            frames += slice
            previous = block
        }
        self = frames
            .enumerated()
            .map({ SMLayoutObjectItem(frame: $0.element, index: $0.offset) })
    }
}

private extension Array where Element == SMLayoutBlockWrapper {
    
    init(pattern: SMLayoutPattern, rows expectedFrames: Int) {
        let blocks: [SMLayoutBlock] = pattern.smLayoutPatternBlocks()
        let blocksNoRepeat = blocks.prefix(while: { $0.smLayoutBlockRepeated() == false }).map({ SMLayoutBlockWrapper($0) })
        let blocksNoRepeatFrames = blocksNoRepeat.map({ $0.smLayoutBlockCapacity() }).reduce(0, +)
        switch blocksNoRepeat.indices.count < blocks.count {
        case true:
            switch blocksNoRepeatFrames < expectedFrames {
            case true:
                let blockToRepeat = SMLayoutBlockWrapper(blocks[blocksNoRepeat.endIndex])
                let blockToRepeatFrames = blockToRepeat.smLayoutBlockCapacity()
                let blockToRepeatRange = 0 ... (expectedFrames - blocksNoRepeatFrames) / blockToRepeatFrames
                self = blocksNoRepeat + Array<Int>(blockToRepeatRange).map({ _ in blockToRepeat })
            case false:
                self = blocksNoRepeat
            }
        case false:
            let blocksNoRepeatRange = 0 ... expectedFrames / blocksNoRepeatFrames
            self = Array<Int>(blocksNoRepeatRange).flatMap({ _ in blocksNoRepeat })
        }
    }
}
