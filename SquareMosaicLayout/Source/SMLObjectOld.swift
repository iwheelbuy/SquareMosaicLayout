import Foundation

public let SquareMosaicLayoutSectionBacker = "SquareMosaicLayout.SquareMosaicLayoutSectionBacker"
public let SquareMosaicLayoutSectionFooter = "SquareMosaicLayout.SquareMosaicLayoutSectionFooter"
public let SquareMosaicLayoutSectionHeader = "SquareMosaicLayout.SquareMosaicLayoutSectionHeader"

protocol SMLContentSize {
    
    func smlContentSize() -> CGSize
}

protocol SMLAttributes {
    
    func smlAttributesForElement(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    func smlAttributesForItem(indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    func smlAttributesForSupplementary(elementKind: String, indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
}
