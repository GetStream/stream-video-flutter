#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint stream_video.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'stream_video'
  s.version          = '0.0.1'
  s.summary          = 'Official Dart Client for Stream Video.'
  s.description      = <<-DESC
Official Dart Client for Stream Video.
                       DESC
  s.homepage         = 'https://github.com/GetStream/stream-video-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jc Miñarro' => 'josecarlos@getstream.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
