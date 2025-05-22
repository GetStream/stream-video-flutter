#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint stream_video_noise_cancellation.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'stream_video_noise_cancellation'
  s.version          = '0.9.4'
  s.summary          = 'Official Noise Cancellation Plugin for Stream Video.'
  s.description      = <<-DESC
Official Noise Cancellation Plugin for Stream Video.
                       DESC
  s.homepage         = 'https://github.com/GetStream/stream-video-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'getstream.io' => 'support@getstream.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'stream_webrtc_flutter'
  s.dependency 'StreamVideoNoiseCancellation'
  s.platform = :ios, '14.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
