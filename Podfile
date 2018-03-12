# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

platform :ios, '9.1'

def shared
#   UI
    pod 'InputMask', '~> 2.2.6'

#   Firebase
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'

#   Notifications
    pod 'NotificationBannerSwift', '~> 1.5.4'
    pod 'Toast-Swift', '~> 3.0.1'

#   Base
    pod 'Swinject', '~> 2.1.0'
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit', '~> 1.3.2'
end

workspace 'RestomaniaCoreFramework.xcworkspace'
project './CoreFrameworkApp/CoreFrameworkApp.xcodeproj'
project './CoreFramework/CoreFramework.xcodeproj'

target 'CoreFramework' do
    project './CoreFramework/CoreFramework.xcodeproj'
    use_frameworks!
    shared

    target 'Kuzina' do
        project './CoreFrameworkApp/CoreFrameworkApp.xcodeproj'
        inherit! :search_paths
        use_frameworks!
    end
end



