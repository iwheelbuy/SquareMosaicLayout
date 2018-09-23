import Foundation
@testable import SquareMosaicLayout

extension String {
    
    static var random: String {
        return "\(Int.random)"
    }
}

extension Int {
    
    static var random: Int {
        return Int(arc4random_uniform(1000)) + 1
    }
}

extension CGRect {
    
    static var random: CGRect {
        return CGRect(x: CGFloat.random, y: CGFloat.random, width: CGFloat.random, height: CGFloat.random)
    }
}

extension CGFloat {
    
    static var random: CGFloat {
        return CGFloat(Int.random)
    }
}

extension Array where Element == SMLObjectItem {
    
    static var random: [SMLObjectItem] {
        return Array<Int>(0 ... Int.random).map({ _ in SMLObjectItem(frame: CGRect.random, index: Int.random) })
    }
}

extension SMLObjectSupplementary {
    
    static var random: SMLObjectSupplementary {
        return SMLObjectSupplementary(frame: CGRect.random, kind: String.random, zIndex: Int.random)
    }
}

extension SMLObjectDirection {
    
    static var random: SMLObjectDirection {
        return SMLObjectDirection(aspect: .random, vertical: Int.random % 2 == 0)
    }
    
    static var horizontal: SMLObjectDirection {
        return SMLObjectDirection(aspect: .random, vertical: false)
    }
    
    static var vertical: SMLObjectDirection {
        return SMLObjectDirection(aspect: .random, vertical: true)
    }
}

extension SMLObjectItem {
    
    static var random: SMLObjectItem {
        return SMLObjectItem(frame: CGRect.random, index: Int.random)
    }
}

extension SMLObjectSection {
    
    static var random: SMLObjectSection {
        return SMLObjectSection(backer: .random, footer: .random, header: .random, index: .random, items: .random, length: .random, origin: .random)
    }
}

extension SMLPosition {
    
    static var random: SMLPosition {
        let positions = [SMLPosition.after, .before, .between]
        let index = Int(arc4random_uniform(UInt32(positions.count)))
        return positions[index]
    }
}
