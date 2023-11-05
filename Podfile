# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'SpyGame' do
  use_frameworks!

  pod 'SwiftGen'
  pod 'SnapKit', '5.6.0'
  pod 'Toast-Swift', '5.0.1'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end