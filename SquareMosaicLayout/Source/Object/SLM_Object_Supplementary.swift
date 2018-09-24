import Foundation

//struct SMLFrame {
//    
//    private let direction: SMLObjectDirection
//    private(set) var frame: CGRect
//    
//    init(direction: SMLObjectDirection, frame: CGRect) {
//        self.direction = direction
//        self.frame = frame
//    }
//    
//    var origin: CGFloat {
//        get {
//            switch direction {
//            case .vertical:
//                return frame.origin.y
//            case .horizontal:
//                return frame.origin.x
//            }
//        }
//        set {
//            switch direction {
//            case .vertical:
//                frame.origin.y = newValue
//            case .horizontal:
//                frame.origin.x = newValue
//            }
//        }
//    }
//}

enum SMLStick {
    
    case bottom, top
}

struct Nice {
    
    let frame: CGRect
    let kind: String
    let range: ClosedRange<CGFloat>
    let stick: SMLStick
    let zIndex: Int
    
    func attributes(direction: SMLObjectDirection, indexPath: IndexPath, visible: SMLVisible) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        var frame = self.frame
        if visible.range.overlaps(self.range) {
            let range = visible.range.clamped(to: self.range)
            let origin = stick == .bottom ? range.upperBound : range.lowerBound
            switch direction {
            case .vertical:
                frame.origin.y = origin
            case .horizontal:
                frame.origin.x = origin
            }
        }
        attributes.frame = frame
        attributes.zIndex = zIndex
        return attributes
    }
}

struct SMLObjectSupplementary: Equatable {
    
    let frame: CGRect
    let kind: String
    let zIndex: Int
    
    init(frame: CGRect, kind: String, zIndex: Int) {
        self.frame = frame
        self.kind = kind
        self.zIndex = zIndex
    }
    
    /// создается
    init(aspect: SMLObjectAspect, direction: SMLObjectDirection, kind: String, length: CGFloat, zIndex: Int) {
        let size: CGSize
        switch direction {
        case .vertical:
            size = CGSize(width: aspect, height: length)
        case .horizontal:
            size = CGSize(width: length, height: aspect)
        }
        self.init(frame: CGRect(origin: .zero, size: size), kind: kind, zIndex: zIndex)
    }
    
    init?(aspect: SMLObjectAspect, direction: SMLObjectDirection, origin: inout CGFloat, supplementary: SMLSupplementary?, zIndex: Int) {
        guard let supplementary = supplementary else {
            return nil
        }
        let frame = supplementary.smlSupplementaryFrame(aspect: aspect, origin: origin)
        let kind = supplementary.smlSupplementaryKind()
        switch direction {
        case .vertical:
            origin += frame.origin.y - origin + frame.size.height
        case .horizontal:
            origin += frame.origin.x - origin + frame.size.width
        }
        self.init(frame: frame, kind: kind, zIndex: zIndex)
    }
    
    func updated(direction: SMLObjectDirection, origin: CGFloat) -> SMLObjectSupplementary {
        var frame = self.frame
        switch direction {
        case .vertical:
            frame.origin.y = origin + frame.origin.y
        case .horizontal:
            frame.origin.x = origin + frame.origin.x
        }
        return SMLObjectSupplementary(frame: frame, kind: kind, zIndex: zIndex)
    }
}
