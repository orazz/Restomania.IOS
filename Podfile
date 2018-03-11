workspace 'Restomania'

platform :ios, '9.1'

def shared_pods
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit', '~> 1.3.2'
end
def injections
    pod 'Swinject', '~> 2.1.0'
end
def notifications
    pod 'NotificationBannerSwift', '~> 1.5.4'
    pod 'Toast-Swift', '~> 3.0.1'
end
def firebase
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
end
def auth
    pod 'InputMask', '~> 2.2.6'
end
def custom_app
    shared_pods
    injections
    notifications
    firebase
    auth
end





#Custom
#Kuzina
target 'Kuzina' do
    project './Apps/Custom.xcodeproj'
    use_frameworks!
    custom_app
end
#target 'SimpleRecipes' do
#    project './Apps/Custom.xcodeproj'
#    custom_app
#end













#App
target 'BaseApp' do
    project './BaseApp/BaseApp.xcodeproj'
    use_frameworks!
    shared_pods
    injections
    firebase
end
#Pages
target 'Launcher' do
    project './Pages/Launcher/Launcher.xcodeproj'
    use_frameworks!
    shared_pods
#    firebase
end
target 'PagesSearch' do
    project './Pages/Search/Search.xcodeproj'
    use_frameworks!
    shared_pods
end
target 'PagesOther' do
    project './Pages/Other/Other.xcodeproj'
    use_frameworks!
    shared_pods
end
target 'PagesPlace' do
    project './Pages/Place/Place.xcodeproj'
    use_frameworks!
    shared_pods
end
target 'PagesTools' do
    project './Pages/Tools/Tools.xcodeproj'
    use_frameworks!
    shared_pods
end


















#UI
target 'UIServices' do
    project './UI/Services/Services.xcodeproj'
    use_frameworks!
    shared_pods
    injections
#    firebase
    auth
end
target 'UIElements' do
    project './UI/Elements/Elements.xcodeproj'
    use_frameworks!
    shared_pods
    notifications
end
target 'UITools' do
    project './UI/Tools/Tools.xcodeproj'
    use_frameworks!
    shared_pods
    injections
    notifications
end














# Common
target 'Notifications' do
    project './Notifications/Notifications.xcodeproj'
    use_frameworks!
    shared_pods
#    firebase
end
target 'Localization' do
    project './Localization/Localization.xcodeproj'
    use_frameworks!
    shared_pods
    injections
end
















# Core
target 'CoreStorageServices' do
    project './Core/StorageServices/StorageServices.xcodeproj'
    use_frameworks!
    shared_pods
    injections
end

target 'CoreApiServices' do
    project './Core/ApiServices/ApiServices.xcodeproj'
    use_frameworks!
    shared_pods
    injections
end

target 'CoreToolsServices' do
    project './Core/ToolsServices/ToolsServices.xcodeproj'
    use_frameworks!
    shared_pods
    injections
end

target 'CoreDomains' do
    project './Core/Domains/Domains.xcodeproj'
    use_frameworks!
    use_frameworks!
    shared_pods
end

target 'CoreTools' do
    project './Core/Tools/Tools.xcodeproj'
    use_frameworks!
    use_frameworks!
    shared_pods
    injections
end

