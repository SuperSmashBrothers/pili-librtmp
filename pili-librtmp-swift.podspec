#
# Be sure to run `pod lib lint pili-librtmp.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "pili-librtmp-swift"
  s.version          = "0.0.1"
  s.summary          = "pili-librtmp is a RTMP client library."
  s.homepage         = "https://github.com/SuperSmashBrothers/pili-librtmp"
  s.license          = 'LGPL'
  s.author           = { "pili" => "jzh16s@hotmail.com" }
  s.source           = { :git => "https://github.com/SuperSmashBrothers/pili-librtmp.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = "Pod/Classes/**/*"
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.0'
  s.exclude_files = "Pod/Classes/pili-librtmp/dh.h", "Pod/Classes/pili-librtmp/handshake.h"
  s.preserve_paths = "pili-librtmp-swift/module.module.map"
  s.module_map = "pili-librtmp-swift/module.modulemap"
  
end
