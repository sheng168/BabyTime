#dropbox
#source 'https://github.com/CocoaPods/Specs.git'

abstract_target 'BabyTime_' do
    use_frameworks!

    pod 'RealmSwift'
    pod 'Then'
    
    #, '= 2.7.0'
#     pod 'Cartography', '~> 1.0.1'
#     pod 'SwiftLint', '= 0.16.1'

    target 'BabyTime' do
        platform :ios, '9.0'
        pod 'RealmLoginKit', :podspec => 'https://raw.githubusercontent.com/realm-demos/realm-loginkit/master/RealmLoginKit%20Apple/RealmLoginKit.podspec'
        pod 'BuddyBuildSDK'

    end

#    target 'BabyTime WatchKit App' do
#        platform :watchos, '3.0'
#    end

    target 'BabyTime WatchKit Extension' do
        platform :watchos, '3.0'
    end
end


