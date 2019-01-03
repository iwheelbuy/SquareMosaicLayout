import CoreGraphics
import Foundation

final class SMLayoutObjectItem {
    
    private(set) var frame: CGRect
    let index: Int
    
    init(frame: CGRect, index: Int) {
        self.frame = frame
        self.index = index
    }
}

extension SMLayoutObjectItem: SMLayoutUpdatable {

    func smLayoutUpdated(direction: SMLayoutDirection, origin: SMLayoutOrigin) {
        switch direction {
        case .vertical:
            frame.origin.y = origin.value + frame.origin.y
        case .horizontal:
            frame.origin.x = origin.value + frame.origin.x
        }
    }
    
    func smLayoutUpdated(visible: SMLayoutVisible) {
        //
    }
    
    func smLayoutUpdateRequired(visible: SMLayoutVisible) -> Bool {
        return false
    }
}
