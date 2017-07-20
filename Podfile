workspace 'Restomania'

platform :ios, '9.1'

def shared_pods
    use_frameworks!
    pod 'Gloss', '~> 1.2'
    pod 'AsyncTask', '~> 0.1.3'
end

target 'RestomaniaAppKuzina' do
    project './Restomania.App.Kuzina/Restomania.App.Kuzina.xcodeproj'
    shared_pods
end
target 'RestomaniaAppKuzina-Tests' do
    project './Restomania.App.Kuzina/Restomania.App.Kuzina.xcodeproj'
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
