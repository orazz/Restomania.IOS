workspace 'Restomania'

platform :ios, '9.1'

def shared_pods
    use_frameworks!
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit'
end


target 'Kuzina' do
    project './Apps/Kuzina/Kuzina.xcodeproj'
    shared_pods
    pod 'Toast-Swift', '~> 3.0.1'
    pod 'NotificationBannerSwift', '~> 1.5.4'
end

target 'CoreApiServices' do
    project './Core/ApiServices/ApiServices.xcodeproj'
    shared_pods
    pod 'Swinject', '~> 1.1.4'
end

target 'CoreToolsServices' do
    project './Core/ToolsServices/ToolsServices.xcodeproj'
    shared_pods
    pod 'Swinject', '~> 1.1.4'
end

target 'CoreDomains' do
    project './Core/Domains/Domains.xcodeproj'
    use_frameworks!
    shared_pods
end

