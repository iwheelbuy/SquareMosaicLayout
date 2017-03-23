# SquareMosaicLayout

![Version](https://img.shields.io/cocoapods/v/SquareMosaicLayout.svg?style=flat)
[![License](https://img.shields.io/cocoapods/l/SquareMosaicLayout.svg?style=flat)](https://raw.githubusercontent.com/iwheelbuy/SquareMosaicLayout/master/LICENSE)
![Platform](https://img.shields.io/cocoapods/p/SquareMosaicLayout.svg?style=flat)


SquareMosaicLayout is an extandable UICollectionViewLayout.

| Example | Layout | Pattern | Blocks |
|:-:|:-:|:-:|:-:|
| ![image1](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/ezgif.com-optimize.gif) | ![image2](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/rsz_1.png) | ![image3](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/rsz_12.png) | ![image4](https://github.com/iwheelbuy/SquareMosaicLayout/blob/master/Example/SquareMosaicLayout/rsz_3.png) |
| Build and run an example project to see how it really works | Let's imagine that we want a UICollectionView with some mosaic layout that looks like this | The red part of frames repeats while scrolling. So we should do only the red __pattern__ and then repeat it | The __pattern__ is split it into smaller __blocks__ that can be reused for some other layout or __pattern__ |

## Installation

SquareMosaicLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SquareMosaicLayout', '0.6.2'
```

## Capabilities

- [x] Each section can have its own header frame (optional).
- [x] Each section can have its own fotter frame (optional).
- [x] Each section can have its own background (optional).
- [x] Space between sections can be changed.
- [x] Layout can be vertical or horizontal.
- [x] Each section can have its own __pattern__ of frames.

## Author

iwheelbuy, iwheelbuy@gmail.com

## License

SquareMosaicLayout is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/iwheelbuy/SquareMosaicLayout/master/LICENSE) file for more info.
