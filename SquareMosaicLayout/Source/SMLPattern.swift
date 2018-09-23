import Foundation

public protocol SMLPattern {
    
    func smlPatternBlocks() -> [SMLBlock]
    func smlPatternSpacing(position: SMLPosition) -> CGFloat
}

extension SMLPattern {
    
    func smlPatternBlocks(rows expectedFrames: Int) -> [SMLBlock] {
        let blocks: [SMLBlock] = smlPatternBlocks()
        let blocksNoRepeat = blocks.prefix(while: { $0.smlBlockRepeated() == false })
        let blocksNoRepeatFrames = blocksNoRepeat.map({ $0.smlBlockCapacity() }).reduce(0, +)
        switch blocksNoRepeat.indices.count < blocks.count {
        case true:
            guard blocksNoRepeatFrames < expectedFrames else {
                return Array(blocksNoRepeat)
            }
            let blockToRepeat = blocks[blocksNoRepeat.endIndex]
            let blockToRepeatFrames = blockToRepeat.smlBlockCapacity()
            let blockToRepeatRange = 0 ... (expectedFrames - blocksNoRepeatFrames) / blockToRepeatFrames
            return Array(blocksNoRepeat) + Array(blockToRepeatRange).map({ _ in blockToRepeat })
        case false:
            let blocksNoRepeatRange = 0 ... expectedFrames / blocksNoRepeatFrames
            return Array<Int>(blocksNoRepeatRange).map({ _ in Array(blocksNoRepeat) }).flatMap({ $0 })
        }
    }
}
