#
#  Be sure to run `pod spec lint OkDataSources.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "OkDataSources"
  s.version      = "0.0.6"
  s.summary      = "Wrappers for iOS TableView and CollectionView DataSources to simplify its api at a minimum."

  s.homepage     = "https://github.com/FuckBoilerplate/OkDataSources"
  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Roberto Frontado" => "robertofrontado@gmail.com" }
  s.source           = { :git => "https://github.com/FuckBoilerplate/OkDataSources.git", :tag => s.version.to_s }
  s.social_media_url   = "https://github.com/FuckBoilerplate"

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'Library/**/*'

  # s.public_header_files = 'Library/**/*.h'

end
