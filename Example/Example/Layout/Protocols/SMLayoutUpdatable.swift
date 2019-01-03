import CoreGraphics
import Foundation

protocol SMLayoutUpdatable: class {
    
    func smLayoutUpdated(direction: SMLayoutDirection, origin: SMLayoutOrigin)
    func smLayoutUpdated(visible: SMLayoutVisible)
    func smLayoutUpdateRequired(visible: SMLayoutVisible) -> Bool
}
