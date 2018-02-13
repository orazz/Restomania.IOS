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

target 'Kuzina' do
    project './Apps/Kuzina/Kuzina.xcodeproj'
    shared_pods
    pod 'NotificationBannerSwift', '~> 1.5.4'
end

target 'CoreUIServices' do
    project './Core/UIServices/UIServices.xcodeproj'
    shared_pods
    injections
    pod 'Toast-Swift', '~> 3.0.1'
end 

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
end

