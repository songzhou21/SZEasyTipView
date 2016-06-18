#
# Be sure to run `pod lib lint SZEasyTipView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SZEasyTipView'
  s.version          = '0.1.0'
  s.summary          = 'Elegant tooltip view written in Objective-C, copy from EasyTipView(https://github.com/teodorpatras/EasyTipView)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
EasyTipView is a fully customisable tooltip view written in Objective-C that can be used as a call to action or informative tip. It can be shown above of below any UIBarItem or UIView subclass.
                       DESC

  s.homepage         = 'https://github.com/gogozs/SZEasyTipView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'Song Zhou' => 'zhousong1993@gmail.com' }
  s.source           = { :git => 'https://github.com/gogozs/SZEasyTipView.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/songzhou21'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SZEasyTipView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SZEasyTipView' => ['SZEasyTipView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
