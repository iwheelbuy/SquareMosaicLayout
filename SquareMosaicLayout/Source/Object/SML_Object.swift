import Foundation

struct SMLObject {
    
    let direction: SMLObjectDirection
    let sections: [SMLObjectSection]
    
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
}

extension SMLObject: SMLAttributes {
    
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

extension SMLObject: SMLContentSize {
    
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
