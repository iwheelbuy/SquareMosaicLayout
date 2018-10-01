import SquareMosaicLayout

let offset: CGFloat = 10.0

class VerticalSupplementary: SMLSupplementary {
    
    let kind: String
    
    init(kind: String) {
        self.kind = kind
    }
    
    func smlSupplementaryFrame(aspect: CGFloat, origin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: aspect, height: offset * 4)
    }
    
    func smlSupplementaryKind() -> String {
        return kind
    }
}

class VerticalMosaicPattern: SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock] {
        return [
            VerticalOneTwoBlock(),
            VerticalTwoOneBlock(),
        ]
    }
    
    func smlPatternSpacing(position: SMLPosition) -> CGFloat {
        return position == .between ? offset : 0.0
    }
}

class VerticalTriplePattern: SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock] {
        return [
            VerticalTripleBlock()
        ]
    }
    
    func smlPatternSpacing(position: SMLPosition) -> CGFloat {
        return position == .between ? offset : 0.0
    }
}

class VerticalSinglePattern: SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock] {
        return [
            VerticalSingleBlock()
        ]
    }
    
    func smlPatternSpacing(position: SMLPosition) -> CGFloat {
        return position == .between ? offset : 0.0
    }
}

public class VerticalOneTwoBlock: SMLBlock {
    
    public func smlBlockRepeated() -> Bool {
        return false
    }

    public func smlBlockCapacity() -> Int {
        return 3
    }
    
    public func smlBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        let min = (aspect - offset * 4) / 3.0
        let max = aspect - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: max, height: max))
        frames.append(CGRect(x: max + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + offset * 2, y: origin + min + offset, width: min, height: min))
        return frames
    }
}

public class VerticalTwoOneBlock: SMLBlock {
    
    public func smlBlockRepeated() -> Bool {
        return false
    }
    
    public func smlBlockCapacity() -> Int {
        return 3
    }
    
    public func smlBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        let min = (aspect - offset * 4) / 3.0
        let max = aspect - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: offset, y: origin + offset + min, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: max, height: max))
        return frames
    }
}

public class VerticalTripleBlock: SMLBlock {
    
    public func smlBlockRepeated() -> Bool {
        return false
    }
    
    public func smlBlockCapacity() -> Int {
        return 3
    }
    
    public func smlBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        let min = (aspect - offset * 4) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: min * 2 + offset * 3, y: origin, width: min, height: min))
        return frames
    }
    
    public func blockRepeated() -> Bool {
        return true
    }
}

public class VerticalSingleBlock: SMLBlock {
    
    public func smlBlockRepeated() -> Bool {
        return false
    }
    
    public func smlBlockCapacity() -> Int {
        return 1
    }
    
    public func smlBlockFrames(aspect: CGFloat, origin: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: aspect - offset - offset, height: aspect - offset - offset))
        return frames
    }
    
    public func blockRepeated() -> Bool {
        return true
    }
}
