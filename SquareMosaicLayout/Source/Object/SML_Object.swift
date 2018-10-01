import Foundation

final class SMLObject {
    
    let aspect: SMLObjectAspect
    let dimension: SMLDimension
    private let direction: SMLObjectDirection
    private let sections: [SMLObjectSection]
    private(set) unowned var source: SMLSource
    private var visible: SMLVisible?
    
    init(aspect: SMLObjectAspect, dimension: SMLDimension, direction: SMLObjectDirection, source: SMLSource, visible: SMLVisible?) {
        self.aspect = aspect
        self.dimension = dimension
        self.direction = direction
        self.sections = {
            guard dimension.sections > 0 else {
                return []
            }
            var origin: CGFloat = 0
            let spacing = source.smlSourceSpacing()
            return Array<Int>(0 ..< dimension.sections)
                .compactMap({ SMLObjectSection(aspect: aspect, direction: direction, rows: dimension[$0], section: $0, source: source) })
                .enumerated()
                .map({ (index, section) -> SMLObjectSection in
                    if index > 0 {
                        origin += spacing
                    }
                    return section.updated(direction: direction, origin: &origin)
                })
        }()
        self.source = source
        self.visible = visible
    }
    
    func updateFor(visible: SMLVisible?) {
        //
    }
    
    func invalidationRequiredFor(visible: SMLVisible?) -> Bool {
        return sections.contains(where: { $0.smlAttributesInvalidationRequired(visible: visible) })
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
    
//    func smlAttributesInvalidationRequired(visible: SMLVisible) -> Bool {
//        guard let section = sections.first(where: { $0.smlAttributesInvalidationRequired(visible: visible) }) else {
//            return false
//        }
//        return true
//    }
    
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
