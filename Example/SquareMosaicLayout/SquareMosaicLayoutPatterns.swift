import SquareMosaicLayout

let offset: CGFloat = 10.0

class VerticalSupplementary: SquareMosaicSupplementary {
    
    func supplementaryFrame(for origin: CGFloat, side: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: side, height: offset * 4)
    }

    func supplementaryHiddenForEmptySection() -> Bool {
        return true
    }
}

class VerticalMosaicPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            VerticalOneTwoBlock(),
            VerticalTwoOneBlock(),
        ]
    }
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return position == .between ? offset : 0.0
    }
}

class VerticalTriplePattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            VerticalTripleBlock()
        ]
    }
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return position == .between ? offset : 0.0
    }
}

class VerticalSinglePattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            VerticalSingleBlock()
        ]
    }
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return position == .between ? offset : 0.0
    }
}

public class VerticalOneTwoBlock: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        let max = side - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: max, height: max))
        frames.append(CGRect(x: max + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + offset * 2, y: origin + min + offset, width: min, height: min))
        return frames
    }
}

public class VerticalTwoOneBlock: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        let max = side - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: offset, y: origin + offset + min, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: max, height: max))
        return frames
    }
}

public class VerticalTripleBlock: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
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

public class VerticalSingleBlock: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 1
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: side - offset - offset, height: side - offset - offset))
        return frames
    }
    
    public func blockRepeated() -> Bool {
        return true
    }
}
