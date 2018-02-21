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





#Custom
#Kuzina
target 'Kuzina' do
    project './Apps/Kuzina/Kuzina.xcodeproj'
    shared_pods
    injections
end

#App
target 'BaseApp' do
    project './BaseApp/BaseApp.xcodeproj'
    shared_pods
    injections
end

















#Pages
target 'StartPages' do
    project './UI/StartPages/StartPages.xcodeproj'
    shared_pods
    injections
end
target 'TabsPages' do
    project './UI/TabsPages/TabsPages.xcodeproj'
    shared_pods
    injections
end
target 'ManagerPages' do
    project './UI/ManagerPages/ManagerPages.xcodeproj'
    shared_pods
    injections
end
target 'PlacePages' do
    project './UI/PlacePages/PlacePages.xcodeproj'
    shared_pods
    injections
end
target 'ToolsPages' do
    project './UI/ToolsPages/ToolsPages.xcodeproj'
    shared_pods
    injections
end


















#UI
target 'UIServices' do
    project './UI/Services/Services.xcodeproj'
    shared_pods
    injections
    pod 'Toast-Swift', '~> 3.0.1'
end
target 'UIElements' do
    project './UI/Elements/Elements.xcodeproj'
    shared_pods
end
target 'UITools' do
    project './UI/Tools/Tools.xcodeproj'
    shared_pods
    injections
    pod 'NotificationBannerSwift', '~> 1.5.4'
    pod 'Toast-Swift', '~> 3.0.1'
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

