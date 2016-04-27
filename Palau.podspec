Pod::Spec.new do |s|
  s.name         = "Palau"
  s.version      = "1.0"
  s.summary      = "Palau: NSUserDefaults with Wings!"
  s.homepage     = "https://github.com/symentis/Palau"
  s.screenshots  = "https://raw.githubusercontent.com/symentis/Palau/master/Resources/palau-logo.png"
  s.license      = "Apache License, Version 2.0"
  s.authors            = { "symentis GmbH" => "github@symentis.com" }
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"
  s.source       = { :git => "https://github.com/symentis/Palau.git", :tag => "1.0.1" }
  s.source_files = 'Palau/*.swift'
end