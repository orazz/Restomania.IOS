workspace 'Restomania'

platform :ios, '9.1'

def shared_pods
    use_frameworks!
    pod 'Gloss', '~> 2.0'
    pod 'AsyncTask'
end


target 'RestomaniaAppKuzina' do
    project './Restomania.App.Kuzina/Restomania.App.Kuzina.xcodeproj'
    shared_pods
    pod 'Toast-Swift', '~> 3.0.1'
    pod 'NotificationBannerSwift', '~> 1.5.4'
end
target 'RestomaniaAppKuzina-Tests' do
    project './Restomania.App.Kuzina/Restomania.App.Kuzina.xcodeproj'
    shared_pods
end


target 'FindMe' do
    project './FindMe/FindMe.xcodeproj'
    shared_pods
end
target 'FindMe-Tests' do
    project './FindMe/FindMe.xcodeproj'
    shared_pods
end


target 'IOSLibrary' do
  project './IOS Library/IOS Library.xcodeproj'
  shared_pods
end
target 'IOSLibraryTests' do
    project './IOS Library/IOS Library.xcodeproj'
    shared_pods
end
