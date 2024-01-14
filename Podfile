# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

target 'Neves_SwiftUI' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
#    pod 'SwiftyJSON'
#    pod 'KakaJSON'
    pod 'JPImageresizerView', :inhibit_warnings => true
    pod 'JPCrop'
#    pod 'SDWebImageSwiftUI'
#    pod 'lottie-ios'
    pod 'Kingfisher', '~> 7.4.0', :inhibit_warnings => true
    pod 'LookinServer', :configurations => ['Debug']
    pod 'FunnyButton_SwiftUI', '~> 0.1.1'
    
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  
end
