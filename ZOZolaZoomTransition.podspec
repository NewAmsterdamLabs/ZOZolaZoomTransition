Pod::Spec.new do |s|
  s.name         = "ZOZolaZoomTransition"
  s.version      = "1.0.0"
  s.summary      = "Zoom transition that animates the entire view heirarchy. It is used extensively in the Zola iOS application."
  s.homepage     = "https://github.com/NewAmsterdamLabs/ZOZolaZoomTransition"
  s.license      = 'MIT'
  s.author       = { "Charles Scalesse" => "charles@zola.com" }
  s.source       = { :git => "https://github.com/NewAmsterdamLabs/ZOZolaZoomTransition.git", :tag => "1.0.0" }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source_files = 'ZOZolaZoomTransition'
  s.requires_arc = true
end
