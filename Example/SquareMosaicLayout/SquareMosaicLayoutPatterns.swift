import SquareMosaicLayout

let offset: CGFloat = 10.0

class SnakeSquareMosaicSupplementary: SquareMosaicSupplementary {
    
    func frame(origin: CGFloat, width: CGFloat) -> CGRect {
        return CGRect(x: 0, y: origin, width: width, height: (width - offset * 4) / 3.0)
    }
}

class SnakeSquareMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            OneTwoSquareMosaicBlock(),
            TwoOneSquareMosaicBlock(),
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class TripleSquareMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            ThreeLeftSquareMosaicBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

class SingleSquareMosaicPattern: SquareMosaicPattern {
    
    func blocks() -> [SquareMosaicBlock] {
        return [
            SingleSquareMosaicBlock()
        ]
    }
    
    func separator(_ type: SquareMosaicSeparatorType) -> CGFloat {
        return type == .middle ? offset : 0.0
    }
}

public class OneTwoSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offset * 4) / 3.0
        let max = width - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: max, height: max))
        frames.append(CGRect(x: max + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + offset * 2, y: origin + min + offset, width: min, height: min))
        return frames
    }
}

public class TwoOneSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offset * 4) / 3.0
        let max = width - min - offset * 3
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: offset, y: origin + offset + min, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: max, height: max))
        return frames
    }
}

public class ThreeLeftSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 3
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        let min = (width - offset * 4) / 3.0
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: min, height: min))
        frames.append(CGRect(x: min + offset * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: min * 2 + offset * 3, y: origin, width: min, height: min))
        return frames
    }
}

public class SingleSquareMosaicBlock: SquareMosaicBlock {
    
    public func frames() -> Int {
        return 1
    }
    
    public func frames(origin: CGFloat, width: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        frames.append(CGRect(x: offset, y: origin, width: width - offset - offset, height: width - offset - offset))
        return frames
    }
}
