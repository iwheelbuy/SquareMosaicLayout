import UIKit

public final class SMLayoutAspect {
    
    private let direction: SMLayoutDirection
    let value: CGFloat
    
    init(direction: SMLayoutDirection, frame: CGRect, insets: UIEdgeInsets) {
        self.direction = direction
        switch direction {
        case .vertical:
            self.value = frame.width - insets.left - insets.right
        case .horizontal:
            self.value = frame.height - insets.top - insets.bottom
        }
    }
    
    init(aspect value: CGFloat, direction: SMLayoutDirection) {
        self.direction = direction
        self.value = value
    }
}

extension SMLayoutAspect: Equatable {
    
    public static func == (lhs: SMLayoutAspect, rhs: SMLayoutAspect) -> Bool {
        return lhs.direction == rhs.direction && lhs.value == rhs.value
    }
}
