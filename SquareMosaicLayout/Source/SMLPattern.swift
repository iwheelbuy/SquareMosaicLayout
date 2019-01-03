import Foundation

public protocol SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock]
    func smlPatternSpacing(previous: SMLBlock, current: SMLBlock) -> CGFloat
}

struct SMLObjectBlockArray {
    
    let blocks: [SMLBlock]
    
    init(pattern: SMLPattern, rows expectedFrames: Int) {
        let blocks: [SMLBlock] = pattern.smlPatternBlocks()
        let blocksNoRepeat = blocks.prefix(while: { $0.smlBlockRepeated() == false })
        let blocksNoRepeatFrames = blocksNoRepeat.map({ $0.smlBlockCapacity() }).reduce(0, +)
        switch blocksNoRepeat.indices.count < blocks.count {
        case true:
            switch blocksNoRepeatFrames < expectedFrames {
            case true:
                let blockToRepeat = blocks[blocksNoRepeat.endIndex]
                let blockToRepeatFrames = blockToRepeat.smlBlockCapacity()
                let blockToRepeatRange = 0 ... (expectedFrames - blocksNoRepeatFrames) / blockToRepeatFrames
                self.blocks = Array(blocksNoRepeat) + Array(blockToRepeatRange).map({ _ in blockToRepeat })
            case false:
                self.blocks = Array(blocksNoRepeat)
            }
        case false:
            let blocksNoRepeatRange = 0 ... expectedFrames / blocksNoRepeatFrames
            self.blocks = Array<Int>(blocksNoRepeatRange).map({ _ in Array(blocksNoRepeat) }).flatMap({ $0 })
        }
    }
}
