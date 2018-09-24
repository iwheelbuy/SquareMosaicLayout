import Foundation

struct SMLObjectItem: Equatable {
    
    let frame: CGRect
    let index: Int
    
    func updated(direction: SMLObjectDirection, origin: CGFloat) -> SMLObjectItem {
        var frame = self.frame
        switch direction {
        case .vertical:
            frame.origin.y = origin + frame.origin.y
        case .horizontal:
            frame.origin.x = origin + frame.origin.x
        }
        return SMLObjectItem(frame: frame, index: index)
    }
}

extension Array where Element == SMLObjectItem {
    
    func updated(direction: SMLObjectDirection, origin: CGFloat) -> [SMLObjectItem] {
        return map({ $0.updated(direction: direction, origin: origin) })
    }
}
