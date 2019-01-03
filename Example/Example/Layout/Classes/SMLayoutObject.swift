import UIKit

final class SMLayoutObject {
    
    let aspect: SMLayoutAspect
    let dimension: SMLayoutDimension
    private let direction: SMLayoutDirection
    private let sections: [SMLayoutObjectSection]
    private(set) unowned var source: SMLayoutSource
    private var visible: SMLayoutVisible?
    
    private init(aspect: SMLayoutAspect, dimension: SMLayoutDimension, direction: SMLayoutDirection, sections: [SMLayoutObjectSection], source: SMLayoutSource, visible: SMLayoutVisible?) {
        self.aspect = aspect
        self.dimension = dimension
        self.direction = direction
        self.sections = sections
        self.source = source
        self.visible = visible
    }
    
    init(aspect: SMLayoutAspect, dimension: SMLayoutDimension, direction: SMLayoutDirection, source: SMLayoutSource, visible: SMLayoutVisible?) {
        self.aspect = aspect
        self.dimension = dimension
        self.direction = direction
        self.sections = {
            guard dimension.sections > 0 else {
                return []
            }
            let origin = SMLayoutOrigin()
            let spacing = source.smLayoutSourceSectionSpacing()
            let sections = Array<Int>(0 ..< dimension.sections)
                .compactMap({ (section: Int) -> SMLayoutObjectSection? in
                    let rows = dimension[section]
                    return SMLayoutObjectSection(
                        aspect: aspect,
                        direction: direction,
                        rows: rows,
                        section: section,
                        source: source
                    )
                })
            sections
                .enumerated()
                .forEach({ (index, section: SMLayoutObjectSection) in
                    if index > 0 {
                        origin.value += spacing
                    }
                    print("origin 0:", origin.value)
                    section.smLayoutUpdated(direction: direction, origin: origin)
                    if let visible = visible {
                        section.smLayoutUpdated(visible: visible)
                    }
                    origin.value += section.length
                    print("origin 1:", origin.value)
                })
            return sections
        }()
        self.source = source
        self.visible = visible
    }
}

extension SMLayoutObject {
    
    func smLayoutUpdated(direction: SMLayoutDirection, origin: SMLayoutOrigin) {
        //
    }
    
    func smLayoutUpdated(visible: SMLayoutVisible) {
        self.sections.forEach({ $0.smLayoutUpdated(visible: visible) })
    }
    
    func smLayoutUpdateRequired(visible: SMLayoutVisible) -> Bool {
        return sections.contains(where: { $0.smLayoutUpdateRequired(visible: visible) })
    }
}

extension SMLayoutObject {
    
    func smLayoutAttributesForElement(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return sections.compactMap({ $0.smLayoutAttributesForElement(rect: rect) }).flatMap({ $0 })
    }
    
    func smLayoutAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sections.compactMap({ $0.smLayoutAttributesForItem(indexPath: indexPath) }).first
    }
    
    func smLayoutAttributesForSupplementary(elementKind: String, indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return sections.compactMap({ $0.smLayoutAttributesForSupplementary(elementKind: elementKind, indexPath: indexPath) }).first
    }

    func smLayoutContentSize() -> CGSize {
        switch sections.last {
        case .some(let section):
            switch direction {
            case .vertical:
                return CGSize(width: aspect.value, height: section.origin + section.length)
            case .horizontal:
                return CGSize(width: section.origin + section.length, height: aspect.value)
            }
        case .none:
            return .zero
        }
    }
}
