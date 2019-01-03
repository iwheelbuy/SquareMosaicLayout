import Foundation

public protocol SMLSource: class {
    ///
    func smlSourceBacker(section: Int) -> String?
    func smlSourceFooter(section: Int) -> SMLSupplementary?
    func smlSourceHeader(section: Int) -> SMLSupplementary?
    func smlSourcePattern(section: Int) -> SMLPattern
    /// Расстояние между секциями
    func smlSourceSectionSpacing() -> CGFloat
}
