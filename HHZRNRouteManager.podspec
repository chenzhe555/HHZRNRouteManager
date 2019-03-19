#
#  Be sure to run `pod spec lint HHZRNRouteManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "HHZRNRouteManager"
  s.version      = "0.0.1"
  s.summary      = "iOS-拆(分)包管理"
  s.description  = "多bundle 多图片 拆包工具"
  s.homepage     = "https://github.com/chenzhe555/HHZRNRouteManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "chenzhe" => "chenzhe@meicai.cn" }
  s.source       = { :git => "https://github.com/chenzhe555/HHZRNRouteManager.git", :tag => "#{s.version}" }
  s.source_files = "HHZRNRouteManager/classes/*.{h,m}"
end
