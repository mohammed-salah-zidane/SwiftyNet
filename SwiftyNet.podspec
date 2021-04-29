Pod::Spec.new do |spec|
  spec.name         = 'SwiftyNet'
  spec.version      = '1.0.0'
  spec.license       = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/mohammed-salah-zidane/SwiftyNet'
  spec.authors      = { 'Mohamed Salah Zidane' => 'mohamed.zidane95@gmail.com' }
  spec.summary      = 'A generic network layer written in swift'
  spec.source       = { :git => 'https://github.com/mohammed-salah-zidane/SwiftyNet.git', :tag => spec.version }
  spec.swift_version = "5.0"
  spec.platform     = :ios, "13.0"
  spec.ios.deployment_target = "13.0"
  spec.vendored_frameworks      = 'SwiftyNet.xcframework'
  spec.dependency 'Alamofire'
end