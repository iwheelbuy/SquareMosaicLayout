# SquareMosaicLayout

[![Version](https://img.shields.io/cocoapods/v/SquareMosaicLayout.svg?style=flat)](https://cocoapods.org/pods/SquareMosaicLayout)
[![License](https://img.shields.io/cocoapods/l/SquareMosaicLayout.svg?style=flat)](https://raw.githubusercontent.com/iwheelbuy/SquareMosaicLayout/master/LICENSE)
![Platform](https://img.shields.io/cocoapods/p/SquareMosaicLayout.svg?style=flat)

An extandable mosaic UICollectionViewLayout with a focus on extremely flexible customizations.

## Note

This layout is not of [waterfall](https://www.raywenderlich.com/107439/uicollectionview-custom-layout-tutorial-pinterest) type. It was designed for layouts where we can predict the size of rectangular box which contains the number of full cells. Check out how to copy [TRMosaicLayout](https://github.com/iwheelbuy/SquareMosaicLayout#example---copying-trmosaiclayout) or [FMMosaicLayout](https://github.com/iwheelbuy/SquareMosaicLayout#example---copying-fmmosaiclayout) using __SquareMosaicLayout__

## Visual

| Example | Layout | Pattern | Blocks |
|:-:|:-:|:-:|:-:|
| ![image1](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/ezgif.com-optimize.gif) | ![image2](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/rsz_1.png) | ![image3](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/rsz_12.png) | ![image4](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/rsz_3.png) |
| Build and run an example project to see how it really works | Let's imagine that we want a UICollectionView with some mosaic layout that looks like this | The red part of frames repeats while scrolling. So we should do only the red __pattern__ and then repeat it | The __pattern__ is split it into smaller __blocks__ that can be reused for some other layout or __pattern__ |

## Installation

SquareMosaicLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SquareMosaicLayout', '4.1.2'
```

## Capabilities

- [x] Layout can be vertical or horizontal.
- [x] Each section can have its own __pattern__ of frames.
- [x] Each section can have its own header frame (optional).
- [x] Each section can have its own footer frame (optional).
- [x] Each section can have its own background (optional).
- [x] Space between sections can be changed (optional).
- [x] Space between, before and after __blocks__ in __pattern__ can be changed (optional).
- [x] Each section can have one repeated __block__.

## Author

iwheelbuy, iwheelbuy@gmail.com

## License

SquareMosaicLayout is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/iwheelbuy/SquareMosaicLayout/master/LICENSE) file for more info.

## Example - copying [TRMosaicLayout](https://github.com/vinnyoodles/TRMosaicLayout)

```swift
final class TRMosaicLayoutCopy: SquareMosaicLayout, SquareMosaicDataSource {
    
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        self.dataSource = self
    }

    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        return TRMosaicLayoutCopyPattern()
    }
}

class TRMosaicLayoutCopyPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            TRMosaicLayoutCopyBlock1(),
            TRMosaicLayoutCopyBlock2()
        ]
    }
}

public class TRMosaicLayoutCopyBlock1: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let minWidth = side / 3.0
        let maxWidth = side - minWidth
        let minHeight = minWidth * 1.5
        let maxHeight = minHeight + minHeight
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: maxWidth, height: maxHeight))
        frames.append(CGRect(x: maxWidth, y: origin, width: minWidth, height: minHeight))
        frames.append(CGRect(x: maxWidth, y: origin + minHeight, width: minWidth, height: minHeight))
        return frames
    }
}

public class TRMosaicLayoutCopyBlock2: SquareMosaicBlock {
    
    public func blockFrames() -> Int {
        return 3
    }
    
    public func blockFrames(origin: CGFloat, side: CGFloat) -> [CGRect] {
        let minWidth = side / 3.0
        let maxWidth = side - minWidth
        let minHeight = minWidth * 1.5
        let maxHeight = minHeight + minHeight
        var frames = [CGRect]()
        frames.append(CGRect(x: 0, y: origin, width: minWidth, height: minHeight))
        frames.append(CGRect(x: 0, y: origin + minHeight, width: minWidth, height: minHeight))
        frames.append(CGRect(x: minWidth, y: origin, width: maxWidth, height: maxHeight))
        return frames
    }
}
```

## Example - copying [FMMosaicLayout](https://github.com/fmitech/FMMosaicLayout)

```swift
final class FMMosaicLayoutCopy: SquareMosaicLayout, SquareMosaicDataSource {
    
    convenience init() {
        self.init(direction: SquareMosaicDirection.vertical)
        self.dataSource = self
    }
    
    func layoutPattern(for section: Int) -> SquareMosaicPattern {
        return FMMosaicLayoutCopyPattern()
    }
}

class FMMosaicLayoutCopyPattern: SquareMosaicPattern {
    
    func patternBlocks() -> [SquareMosaicBlock] {
        return [
            FMMosaicLayoutCopyBlock1(),
            FMMosaicLayoutCopyBlock2(),
            FMMosaicLayoutCopyBlock3(),
            FMMosaicLayoutCopyBlock2(),
            FMMosaicLayoutCopyBlock2()
        ]
    }
}

public class FMMosaicLayoutCopyBlock1: SquareMosaicBlock {
    
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

public class FMMosaicLayoutCopyBlock2: SquareMosaicBlock {
    
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

public class FMMosaicLayoutCopyBlock3: SquareMosaicBlock {
    
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
```
