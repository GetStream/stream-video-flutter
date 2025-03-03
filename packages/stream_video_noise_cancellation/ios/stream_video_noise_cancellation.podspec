#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint stream_video_noise_cancellation.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'stream_video_noise_cancellation'
  s.version          = '0.0.1'
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
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'stream_video_noise_cancellation_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
