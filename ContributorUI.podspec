Pod::Spec.new do |spec|
    spec.name          = 'ContributorUI'
    spec.version       = '1.0.1'
    spec.license       = { :type => 'MIT', :file => 'LICENSE' }
    spec.homepage      = 'https://github.com/dscyrescotti/ContributorUI'
    spec.authors       = { 'Dscyre Scotti' => 'dscyrescotti@gmail.com' }
    spec.summary       = 'A UI library for iOS and macOS applications to showcase all contributors of public or private repositories.'
    spec.source        = { :git => 'https://github.com/dscyrescotti/ContributorUI.git', :tag => 'v1.0.1' }
    spec.swift_versions = ['5.7']
  
    spec.ios.deployment_target  = '16.0'
    spec.macos.deployment_target  = '13.0'
  
    spec.source_files  = 'Sources/ContributorUI/**/*.swift'
    spec.resource = 'Sources/ContributorUI/Resources/*'
  
    spec.framework     = 'SwiftUI', 'Combine', 'Foundation'

    spec.dependency 'Kingfisher', '~> 7.6.2'
end