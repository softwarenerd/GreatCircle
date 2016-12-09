Pod::Spec.new do |spec|
  spec.name             = 'GreatCircle'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'MIT' }
  spec.homepage         = 'https://github.com/softwarenerd/GreatCircle'
  spec.author           = { 'Brian Lambert' => 'brianlambert@gmail.com' }
  spec.summary          = 'iOS framework that provides a set of Geodesy extensions to the CLLocation class.'
  spec.source           = { :git => 'https://github.com/softwarenerd/GreatCircle.git', :tag => 'v1.0.0' }
  spec.source_files     = 'GreatCircle/CLLocation+GreatCircleExtensions.{h,m}'
  spec.framework        = 'Foundation'
  spec.framework        = 'CoreLocation'
  spec.requires_arc     = true
end