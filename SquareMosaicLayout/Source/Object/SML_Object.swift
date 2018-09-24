import Foundation

struct SMLObject {
    
    let direction: SMLObjectDirection
    let sections: [SMLObjectSection]
    
    init(direction: SMLObjectDirection, sections: [SMLObjectSection]) {
        self.direction = direction
        self.sections = sections
    }
    
    init(dimension: SMLDimension, direction: SMLObjectDirection, source: SMLSource) {
        self.direction = direction
        let sections = dimension.sections
        switch sections {
        case 1...:
            var origin: CGFloat = 0
            let spacing = source.smlSourceSpacing()
            self.sections = Array<Int>(0 ..< sections)
                .compactMap({ SMLObjectSection(dimension: dimension, direction: direction, section: $0, source: source) })
                .enumerated()
                .map({ (index, section) -> SMLObjectSection in
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
    
    func invalidationRequiredFor(visible: SMLVisible) -> Bool {
        return true
    }
    
    func updated(visible: SMLVisible) -> SMLObject {
        guard smlAttributesInvalidationRequired(visible: visible) else {
            return self
        }
        return SMLObject(direction: direction, sections: sections.map({ $0.updated(visible: visible) }))
    }
}

extension SMLObject {
    
    func smlAttributesForElement(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return sections.compactMap({ $0.smlAttributesForElement(rect: rect) }).flatMap({ $0 })
    }
    
    func smlAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sections.compactMap({ $0.smlAttributesForItem(indexPath: indexPath) }).first
    }
    
    func smlAttributesForSupplementary(elementKind: String, indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sections.compactMap({ $0.smlAttributesForSupplementary(elementKind: elementKind, indexPath: indexPath) }).first
    }
    
    func smlAttributesInvalidationRequired(visible: SMLVisible) -> Bool {
        guard let section = sections.first(where: { $0.smlAttributesInvalidationRequired(visible: visible) }) else {
            return false
        }
        print(section.index)
        return true
    }
    
    func smlContentSize() -> CGSize {
        switch sections.last {
        case .some(let section):
            let aspect = direction.aspect
            let vertical = direction.vertical
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
}
