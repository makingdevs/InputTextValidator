#
# Be sure to run `pod lib lint InputValidator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'InputValidator'
  s.version          = '0.1.0'
  s.summary          = 'Library to make validations of the input in some text components.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Use this libary to encapsulate text input compoenents validations and execute all these with one call
                       DESC

  s.homepage         = 'https://github.com/makingdevs/InputValidator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'marcoreyesc' => 'antonio@makingdevs.com' }
  s.source           = { :git => 'https://github.com/makingdevs/InputValidator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/makingdevs'

  s.ios.deployment_target = '8.0'

  s.source_files = 'InputValidator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'InputValidator' => ['InputValidator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.swift_version = '4.0'
end
