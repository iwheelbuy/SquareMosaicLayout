import CoreGraphics
import Foundation

public protocol SMLayoutSource: class {
    ///
    func smLayoutSourceBacker(section: Int) -> String?
    func smLayoutSourceFooter(section: Int) -> SMLayoutSupplementary?
    func smLayoutSourceHeader(section: Int) -> SMLayoutSupplementary?
    func smLayoutSourcePattern(section: Int) -> SMLayoutPattern
    /// Расстояние между секциями
    func smLayoutSourceSectionSpacing() -> CGFloat
}
