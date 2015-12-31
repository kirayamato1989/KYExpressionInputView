#KYExpressionInputView.podspec
Pod::Spec.new do |s|
  s.name         = "KYExpressionInputView"
  s.version      = "0.1"
  s.summary      = "an inputView for easily custom expression"

  s.homepage     = "https://github.com/kirayamato1989/KYExpressionInputView"
  s.license      = 'MIT'
  s.author       = { "Kira Yamato" => "https://github.com/kirayamato1989" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/kirayamato1989/KYExpressionInputView.git", :tag => s.version}
  s.source_files  = 'KYExpressionInputView/*.{h,m}'
  s.resources = "KYExpressionInputView/*.bundle"
  s.requires_arc = true
end
