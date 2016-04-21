#
# Be sure to run `pod lib lint LGLinearFlow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "LGMagnifyingLinearFlowLayout"
  s.version          = "0.1.0"
  s.summary          = "UICollectionViewFlowLayout with zoom effect and variable page size"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC

LGMagnifyingLinearFlowLayout is simple linar flow layout (similar to a carousel without infinite scrolling) that magnifies the centered item.

                       DESC

  s.homepage         = "https://github.com/lukagabric/LGLinearFlow"
  s.screenshots     = "https://github.com/lukagabric/LGLinearFlow/screenshot.png"
  s.license          = 'MIT'
  s.authors           = { "Luka Gabrić" => "luka.gabric@gmail.com", 
                          "Reiner Pittinger" => "rp@digital-wave.de" }
  s.source           = { :git => "https://github.com/lukagabric/LGLinearFlow.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LGMagnifyingLinearFlowLayout/Classes/**/*'
  s.frameworks = 'UIKit'
end
