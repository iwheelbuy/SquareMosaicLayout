# git tag 4.1.2
# git push origin 4.1.2
# pod lib lint SquareMosaicLayout.podspec --no-clean
# pod spec lint SquareMosaicLayout.podspec --allow-warnings
# pod trunk push SquareMosaicLayout.podspec
#

Pod::Spec.new do |s|

  s.name                    = 'SquareMosaicLayout'
  s.version                 = '4.1.2'
  s.summary                 = 'Custom UICollectionViewLayout'
  s.description             = 'Custom UICollectionViewLayout to be used with square UICollectionViewCells'
  s.homepage                = 'https://github.com/iwheelbuy/SquareMosaicLayout'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'iWheelBuy' => 'iwheelbuy@gmail.com' }
  s.source                  = { :git => 'https://github.com/iwheelbuy/SquareMosaicLayout.git', :tag => s.version.to_s }
  s.ios.deployment_target   = '9.0'
  s.source_files            = 'SquareMosaicLayout/*.swift'

end
