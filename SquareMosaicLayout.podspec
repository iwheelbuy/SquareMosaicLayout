#
# Be sure to run `pod lib lint SquareMosaicLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name             = 'SquareMosaicLayout'
  s.version          = '0.0.1'
  s.summary          = 'Custom UICollectionViewLayout'
  s.description      = 'Custom UICollectionViewLayout'
  s.homepage         = 'https://github.com/iwheelbuy/SquareMosaicLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'iWheelBuy' => 'iwheelbuy@protonmail.com' }
  s.source           = { :git => 'https://github.com/iwheelbuy/SquareMosaicLayout.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SquareMosaicLayout/Classes/**/*'

end
