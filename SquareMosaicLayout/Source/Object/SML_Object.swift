import Foundation

struct SMLObject {
    
    let aspect: SMLObjectAspect
    let direction: SMLObjectDirection
    let sections: [SMLObjectSection]
    
    init(aspect: SMLObjectAspect, direction: SMLObjectDirection, sections: [SMLObjectSection]) {
        self.aspect = aspect
        self.direction = direction
        self.sections = sections
    }
    
    init(aspect: SMLObjectAspect, dimension: SMLDimension, direction: SMLObjectDirection, source: SMLSource) {
        self.aspect = aspect
        self.direction = direction
        let sections = dimension.sections
        switch sections {
        case 1...:
            var origin: CGFloat = 0
            let spacing = source.smlSourceSpacing()
            self.sections = Array<Int>(0 ..< sections)
                .compactMap({ SMLObjectSection(aspect: aspect, dimension: dimension, direction: direction, section: $0, source: source) })
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
    
    func updated(aspect: SMLObjectAspect, direction: SMLObjectDirection, visible: SMLVisible) -> SMLObject {
        guard smlAttributesInvalidationRequired(visible: visible) else {
            return self
        }
        return SMLObject(aspect: aspect, direction: direction, sections: sections.map({ $0.updated(direction: direction, visible: visible) }))
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
            switch direction {
            case .vertical:
                return CGSize(width: aspect, height: section.origin + section.length)
            case .horizontal:
                return CGSize(width: section.origin + section.length, height: aspect)
            }
        case .none:
            return .zero
        }
    }
}
