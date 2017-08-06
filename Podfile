source 'https://github.com/CocoaPods/Specs.git'

abstract_target 'BabyTime_' do
    use_frameworks!

    pod 'RealmSwift'
    #, '= 2.7.0'
#     pod 'Cartography', '~> 1.0.1'
#     pod 'SwiftLint', '= 0.16.1'

    target 'BabyTime' do
        platform :ios, '9.0'
#        pod 'RealmLoginKit'
    end

#     target 'BabyTime WatchKit App' do
#         platform :watchos, '3.0'
#     end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            # Signing
            config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
        end
    end
end
