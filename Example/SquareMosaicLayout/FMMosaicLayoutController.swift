import UIKit
import SquareMosaicLayout

final class FMMosaicLayoutController: UIViewController, UICollectionViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: FMMosaicLayout())
        collection.register(UICollectionViewCell.self)
        collection.dataSource = self
        self.title = "FMMosaicLayout"
        self.view = collection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 49
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueCell(indexPath: indexPath)
        cell.contentView.backgroundColor = UIColor.init(white: (30.0 + CGFloat(indexPath.row * 4)) / 255.0, alpha: 1.0)
        return cell
    }
}

final class FMMosaicLayout: SquareMosaicLayout, SquareMosaicDataSource {
    
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        self.dataSource = self
    }
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        return FMMosaicLayoutPattern()
    }
    
    func layoutSeparatorBetweenSections() -> CGFloat {
        return 0
    }
    
    func layoutSupplementaryBackerRequired(for section: Int) -> Bool {
        return false
    }
    
    func layoutSupplementaryFooter(for section: Int) -> SquareMosaicSupplementary? {
        return nil
    }
    
    func layoutSupplementaryHeader(for section: Int) -> SquareMosaicSupplementary? {
        return nil
    }
}

class FMMosaicLayoutPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            FMMosaicLayoutBlock1(),
            FMMosaicLayoutBlock2(),
            FMMosaicLayoutBlock3(),
            FMMosaicLayoutBlock2(),
            FMMosaicLayoutBlock2()
        ]
    }
    
    func patternBlocksSeparator(at position: SquareMosaicBlockSeparatorPosition) -> CGFloat {
        return 0.0
    }
}

public class FMMosaicLayoutBlock1: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 5
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = side / 4.0
        let max = side - min - min
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: max, height: max))
        frames.append(CGRect(x: max, y: origin, width: min, height: min))
        frames.append(CGRect(x: max, y: origin + min, width: min, height: min))
        frames.append(CGRect(x: max + min, y: origin, width: min, height: min))
        frames.append(CGRect(x: max + min, y: origin + min, width: min, height: min))
        return frames
    }
}

public class FMMosaicLayoutBlock2: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 4
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = side / 4.0
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: min, height: min))
        frames.append(CGRect(x: min, y: origin, width: min, height: min))
        frames.append(CGRect(x: min * 2, y: origin, width: min, height: min))
        frames.append(CGRect(x: min * 3, y: origin, width: min, height: min))
        return frames
    }
}

public class FMMosaicLayoutBlock3: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 5
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let min = side / 4.0
        let max = side - min - min
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: min, height: min))
        frames.append(CGRect(x: 0, y: origin + min, width: min, height: min))
        frames.append(CGRect(x: min, y: origin, width: min, height: min))
        frames.append(CGRect(x: min, y: origin + min, width: min, height: min))
        frames.append(CGRect(x: max, y: origin, width: max, height: max))
        return frames
    }
}
