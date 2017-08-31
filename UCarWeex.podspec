#
# Be sure to run `pod lib lint UCarWeex.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UCarWeex'
  s.version          = '0.1.0'
  s.summary          = 'A short description of UCarWeex.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = <<-DESC
                   THIS IS A SHORT DESC OF UCARWEEX
                   DESC

  s.homepage         = 'http://10.3.4.127:8888/mat/ucar-weex'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'huyujin' => 'yujin.hu@ucarinc.com' }

  s.platform         = :ios
  s.ios.deployment_target = '8.0'

  s.source           = { :git => 'http://10.3.4.127:8888/mat/ucar-weex.git', :tag => s.version.to_s }
  s.source_files     = 'platforms/ios/UCarWeex/Source/**/*.{h,m,mm,c}'
#  s.resources = 'platforms/ios/UCarWeex/WeexSDK/pre-build/native-bundle-main.js', 'platforms/ios/UCarWeex/WeexSDK/Resources/wx_load_error@3x.png'

  s.user_target_xcconfig  = { 'FRAMEWORK_SEARCH_PATHS' => "'$(PODS_ROOT)/UCarWeex'" }
#  s.prefix_header_file = 'platforms/ios/UCarWeex/WeexSDK/Sources/Supporting Files/WeexSDK-Prefix.pch'
#  s.xcconfig = { "OTHER_LINK_FLAG" => '$(inherited) -ObjC'}
  s.requires_arc = true

#  s.frameworks = 'CoreMedia','MediaPlayer','AVFoundation','AVKit','JavaScriptCore', 'GLKit', 'OpenGLES', 'CoreText', 'QuartzCore', 'CoreGraphics'
#  s.libraries = 'stdc++'
#  s.vendored_frameworks = 'platforms/ios/UCarWeex/VendoredFrameworks/TBWXDevTool.framework'
#  s.dependency 'SocketRocket'
   s.dependency 'WeexSDK'

#  s.subspec 'Extend' do |ss|
#    ss.source_files = 'platforms/ios/UCarWeex/Extend/**/*.{h,m,mm,c}'
#  end

end
