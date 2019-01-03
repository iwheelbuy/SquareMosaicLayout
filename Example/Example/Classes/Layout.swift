import UIKit

private struct Block0Left: SMLayoutBlock {
    
    private let offset: CGFloat
    
    init(offset: CGFloat) {
        self.offset = offset
    }
    
    func smLayoutBlockCapacity() -> Int {
        return 3
    }
    
    func smLayoutBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        let min = (aspect - offset * 4) / 3.0
        let max = aspect - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: max, height: max))
        frames.append(CGRect(x: max + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + offset * 2, y: origin + min + offset, width: min, height: min))
        return frames
    }
    
    func smLayoutBlockRepeated() -> Bool {
        return false
    }
}

private struct Block0Right: SMLayoutBlock {
    
    private let offset: CGFloat
    
    init(offset: CGFloat) {
        self.offset = offset
    }
    
    func smLayoutBlockCapacity() -> Int {
        return 3
    }
    
    func smLayoutBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        let min = (aspect - offset * 4) / 3.0
        let max = aspect - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: offset, y: origin + offset + min, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: max, height: max))
        return frames
    }
    
    func smLayoutBlockRepeated() -> Bool {
        return false
    }
}

private struct Block0Triple: SMLayoutBlock {
    
    private let offset: CGFloat
    
    init(offset: CGFloat) {
        self.offset = offset
    }
    
    func smLayoutBlockCapacity() -> Int {
        return 3
    }
    
    func smLayoutBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        let min = (aspect - offset * 4) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: min * 2 + offset * 3, y: origin, width: min, height: min))
        return frames
    }
    
    func smLayoutBlockRepeated() -> Bool {
        return false
    }
}

private struct Header0: SMLayoutSupplementary {

    func smLayoutSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: aspect, height: 44)
    }
    
    func smLayoutSupplementaryKind() -> String {
        return Layout.Constants.header0
    }
    
    func smLayoutSupplementarySticky() -> Bool {
        return true
    }
}

private struct Footer0: SMLayoutSupplementary {
    
    func smLayoutSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: aspect, height: 20)
    }
    
    func smLayoutSupplementaryKind() -> String {
        return Layout.Constants.footer0
    }
    
    func smLayoutSupplementarySticky() -> Bool {
        return true
    }
}

private struct Pattern0: SMLayoutPattern {
    
    private let offset: CGFloat
    
    init(offset: CGFloat) {
        self.offset = offset
    }
    
    func smLayoutPatternBlocks() -> [SMLayoutBlock] {
        return [
            Block0Left(offset: offset),
            Block0Triple(offset: offset),
            Block0Right(offset: offset),
            Block0Triple(offset: offset)
        ]
    }
    
    func smLayoutPatternSpacing(previous: SMLayoutBlock, current: SMLayoutBlock) -> CGFloat {
        return offset
    }
}

final class Layout: SMLayout, SMLayoutSource {
    
    enum Constants {
        
        static let backer0: String = "backer0"
        static let footer0: String = "footer0"
        static let header0: String = "header0"
    }
    
    private var offset: CGFloat = 0
    
    convenience init(offset: CGFloat) {
        self.init(direction: .vertical)
        self.offset = offset
        self.source = self
    }
    
    func smLayoutSourcePattern(section: Int) -> SMLayoutPattern {
        switch section {
        case 0, 1:
            return Pattern0(offset: offset)
        default:
            fatalError()
        }
    }
    
    func smLayoutSourceBacker(section: Int) -> String? {
        switch section {
        case 0, 1:
            return Constants.backer0
        default:
            return nil
        }
    }
    
    func smLayoutSourceSectionSpacing() -> CGFloat {
        return offset
    }
    
    func smLayoutSourceFooter(section: Int) -> SMLayoutSupplementary? {
        switch section {
        case 0, 1:
            return Footer0()
        default:
            return nil
        }
    }
    
    func smLayoutSourceHeader(section: Int) -> SMLayoutSupplementary? {
        switch section {
        case 0, 1:
            return Header0()
        default:
            return nil
        }
    }
}
