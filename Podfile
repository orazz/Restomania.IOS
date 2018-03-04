workspace 'Restomania'

platform :ios, '9.1'

def shared_pods
    use_frameworks!
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit'
end
def injections
    pod 'Swinject', '~> 2.1.0'
end
def notifications
    pod 'NotificationBannerSwift', '~> 1.5.4'
    pod 'Toast-Swift', '~> 3.0.1'
end
def custom_app
    shared_pods
    injections
end





#Custom
#Kuzina
target 'Kuzina' do
    project './Apps/Custom.xcodeproj'
#    target 'Kuzina'
    custom_app
end
#target 'SimpleRecipes' do
#    project './Apps/Custom.xcodeproj'
#    custom_app
#end













#App
target 'BaseApp' do
    project './BaseApp/BaseApp.xcodeproj'
    shared_pods
    injections
end
#Pages
target 'Launcher' do
    project './Pages/Launcher/Launcher.xcodeproj'
    shared_pods
end
target 'PagesSearch' do
    project './Pages/Search/Search.xcodeproj'
    shared_pods
end
target 'PagesOther' do
    project './Pages/Other/Other.xcodeproj'
    shared_pods
end
target 'PagesPlace' do
    project './Pages/Place/Place.xcodeproj'
    shared_pods
end
target 'PagesTools' do
    project './Pages/Tools/Tools.xcodeproj'
    shared_pods
end


















#UI
target 'UIServices' do
    project './UI/Services/Services.xcodeproj'
    shared_pods
    injections
end
target 'UIElements' do
    project './UI/Elements/Elements.xcodeproj'
    shared_pods
    notifications
end
target 'UITools' do
    project './UI/Tools/Tools.xcodeproj'
    shared_pods
    injections
    notifications
end














# Common
target 'Notifications' do
    project './Notifications/Notifications.xcodeproj'
    shared_pods
end
target 'Localization' do
    project './Localization/Localization.xcodeproj'
    shared_pods
    injections
end
















# Core
target 'CoreStorageServices' do
    project './Core/StorageServices/StorageServices.xcodeproj'
    shared_pods
    injections
end

target 'CoreApiServices' do
    project './Core/ApiServices/ApiServices.xcodeproj'
    shared_pods
    injections
end

target 'CoreToolsServices' do
    project './Core/ToolsServices/ToolsServices.xcodeproj'
    shared_pods
    injections
end

target 'CoreDomains' do
    project './Core/Domains/Domains.xcodeproj'
    use_frameworks!
    shared_pods
end

target 'CoreTools' do
    project './Core/Tools/Tools.xcodeproj'
    use_frameworks!
    shared_pods
    injections
end

