
Pod::Spec.new do |s|
  s.name         = "AndroidTextField"
  s.version      = "1.0.0"
  s.summary      = "A text field class like Android text field"
  s.description  = "This pod creates a custom textField class that looks like Android textField."
  s.homepage     = "https://github.com/deonisiy162980/AndroidTextField"
  s.license      = "MIT"
  s.author       = "Denis Petrov"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/deonisiy162980/AndroidTextField", :tag => "1.0.0" }
  s.source_files  = "AndroidTextField", "AndroidTextField/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }

end
