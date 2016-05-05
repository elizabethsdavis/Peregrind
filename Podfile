platform :ios, '9.2'

xcodeproj 'Netwerk'

target :Netwerk, :exclusive => true do
pod 'Parse'
pod 'ParseUI'
pod 'ParseFacebookUtilsV4'
pod 'ParseTwitterUtils'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
end

post_install do |installer|
installer.pods_project.build_configuration_list.build_configurations.each do |configuration|
configuration.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
end
end