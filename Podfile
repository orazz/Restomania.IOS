workspace 'Restomania'

platform :ios, '9.1'

def shared_pods
    use_frameworks!
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit'
    pod 'Toast-Swift', '~> 3.0.1'
    pod 'NotificationBannerSwift', '~> 1.5.4'
end


target 'Kuzina' do
    project './Apps/Kuzina/Kuzina.xcodeproj'
    shared_pods
end

target 'CoreDomains' do
    project './Core/Domains/Domains.xcodeproj'
    use_frameworks!
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit'
end
