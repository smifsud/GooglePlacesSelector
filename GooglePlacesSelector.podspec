#
# Be sure to run `pod lib lint GooglePlacesSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GooglePlacesSelector'
  s.version          = '0.1.0'
  s.summary          = 'An easy to use Swift 3.0 Google Web Places API wrapper.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
An easy to use Swift Google Web Places API wrapper that be implemented programmatically. Broadcasts events with place detail information that can be easily observed throughout your app.
                       DESC

  s.homepage         = 'https://github.com/smifsud/GooglePlacesSelector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'smifsud' => 'spiro@materialcause' }
  s.source           = { :git => 'https://github.com/smifsud/GooglePlacesSelector.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/materialcause1'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GooglePlacesSelector/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GooglePlacesSelector' => ['GooglePlacesSelector/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
