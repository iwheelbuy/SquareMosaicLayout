# Changelog

## [4.1.1] - 27-02-2018

- Default value for `supplementaryHiddenForEmptySection` is changed from `true` to `false`. Trying to hide supplementary for empty section might cause NSExceptions to be thrown (tested on [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources)). That is why it is not recommended to use it.
