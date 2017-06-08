# git tag 0.7.0
# git push origin 0.7.0
# pod lib lint SquareMosaicLayout.podspec --no-clean
# pod spec lint SquareMosaicLayout.podspec --allow-warnings
# pod trunk push SquareMosaicLayout.podspec
#
# http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|

  s.name                    = 'SquareMosaicLayout'
  s.version                 = '0.7.0'
  s.summary                 = 'Custom UICollectionViewLayout'
  s.description             = 'Custom UICollectionViewLayout to be used with square UICollectionViewCells'
  s.homepage                = 'https://github.com/iwheelbuy/SquareMosaicLayout'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'iWheelBuy' => 'iwheelbuy@protonmail.com' }
  s.source                  = { :git => 'https://github.com/iwheelbuy/SquareMosaicLayout.git', :tag => s.version.to_s }
  s.ios.deployment_target   = '8.0'
  s.source_files            = 'SquareMosaicLayout/Classes/**/*'

end
