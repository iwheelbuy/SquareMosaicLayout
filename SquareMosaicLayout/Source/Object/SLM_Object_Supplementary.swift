import Foundation

struct SMLObjectSupplementary: Equatable {
    
    let frame: CGRect
    let kind: String
    let zIndex: Int
    
    init(frame: CGRect, kind: String, zIndex: Int) {
        self.frame = frame
        self.kind = kind
        self.zIndex = zIndex
    }
    
    init(direction: SMLObjectDirection, kind: String, length: CGFloat, zIndex: Int) {
        let size: CGSize
        switch direction.vertical {
        case true:
            size = CGSize(width: direction.aspect, height: length)
        case false:
            size = CGSize(width: length, height: direction.aspect)
        }
        self.init(frame: CGRect(origin: .zero, size: size), kind: kind, zIndex: zIndex)
    }
    
    init?(direction: SMLObjectDirection, origin: inout CGFloat, supplementary: SMLSupplementary?, zIndex: Int) {
        guard let supplementary = supplementary else {
            return nil
        }
        let aspect = direction.aspect
        let frame = supplementary.smlSupplementaryFrame(aspect: aspect, origin: origin)
        let kind = supplementary.smlSupplementaryKind()
        let vertical = direction.vertical
        switch vertical {
        case true:
            origin += frame.origin.y - origin + frame.size.height
        case false:
            origin += frame.origin.x - origin + frame.size.width
        }
        self.init(frame: frame, kind: kind, zIndex: zIndex)
    }
    
    func updated(direction: SMLObjectDirection, origin: CGFloat) -> SMLObjectSupplementary {
        var frame = self.frame
        let vertical = direction.vertical
        switch vertical {
        case true:
            frame.origin.y = origin + frame.origin.y
        case false:
            frame.origin.x = origin + frame.origin.x
        }
        return SMLObjectSupplementary(frame: frame, kind: kind, zIndex: zIndex)
    }
}
