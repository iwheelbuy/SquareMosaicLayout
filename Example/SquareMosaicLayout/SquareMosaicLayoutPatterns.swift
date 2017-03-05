import SquareMosaicLayout

let offset: CGFloat = 10.0

class HorizontalSupplementary: SquareMosaicSupplementary {
    
    func frame(origin: CGFloat, side: CGFloat) -> CGRect {
        return CGRect(x: origin, y: 0, width: offset * 4, height: side)
    }
}

class VerticalSupplementary: SquareMosaicSupplementary {
    
    func dynamic() -> Bool {
        return true
    }
    
    func frame(origin: CGFloat, side: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: side, height: offset * 4)
    }
}

class HorizontalMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            HorizontalOneTwoBlock(),
            HorizontalTwoOneBlock(),
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class VerticalMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            VerticalOneTwoBlock(),
            VerticalTwoOneBlock(),
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class HorizontalTriplePattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            HorizontalTripleBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class VerticalTriplePattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            VerticalTripleBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class HorizontalSinglePattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            HorizontalSingleBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class VerticalSinglePattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            VerticalSingleBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

public class HorizontalOneTwoBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        let max = side - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: origin, y: offset, width: max, height: max))
        frames.append(CGRect(x: origin, y: max + offset * 2, width: min, height: min))
        frames.append(CGRect(x: origin + min + offset, y: max + offset * 2, width: min, height: min))
        return frames
    }
}

public class VerticalOneTwoBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        let max = side - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: max, height: max))
        frames.append(CGRect(x: max + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + offset * 2, y: origin + min + offset, width: min, height: min))
        return frames
    }
}

public class HorizontalTwoOneBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        let max = side - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: origin, y: offset, width: min, height: min))
        frames.append(CGRect(x: origin + offset + min, y: offset, width: min, height: min))
        frames.append(CGRect(x: origin, y: min + offset * 2, width: max, height: max))
        return frames
    }
}

public class VerticalTwoOneBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        let max = side - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: offset, y: origin + offset + min, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: max, height: max))
        return frames
    }
}

public class HorizontalTripleBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: origin, y: offset, width: min, height: min))
        frames.append(CGRect(x: origin, y: min + offset * 2, width: min, height: min))
        frames.append(CGRect(x: origin, y: min * 2 + offset * 3, width: min, height: min))
        return frames
    }
}

public class VerticalTripleBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = (side - offset * 4) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: min * 2 + offset * 3, y: origin, width: min, height: min))
        return frames
    }
}

public class HorizontalSingleBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 1
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: origin, y: offset, width: side - offset - offset, height: side - offset - offset))
        return frames
    }
}

public class VerticalSingleBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 1
    }
    
    public func frames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: side - offset - offset, height: side - offset - offset))
        return frames
    }
}
