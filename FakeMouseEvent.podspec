#
# Be sure to run `pod lib lint FakeMouseEvent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FakeMouseEvent'
  s.version          = '0.1.1'
  s.summary          = 'A framework for generating mouse events.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A framework for generating mouse events. Using IOKit(HID library) and CGEvent.
                       DESC

  s.homepage         = 'https://github.com/raxcat/FakeMouseEvent'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'raxcat' => 'raxcat@gmail.com' }
  s.source           = { :git => 'https://github.com/raxcat/FakeMouseEvent.git', :tag => s.version.to_s }

  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'FakeMouseEvent/Classes/**/*'

end
