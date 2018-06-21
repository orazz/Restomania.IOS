# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

platform :ios, '9.1'
use_frameworks!

def shared
#   UI
    pod 'InputMask', '~> 2.2.6'

#   Firebase
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'

#   GoogleMaps
    pod 'GoogleMaps'

#   Notifications
    pod 'NotificationBannerSwift', '~> 1.5.4'
    pod 'Toast-Swift', '~> 3.0.1'

#   Base
    pod 'Swinject', '~> 2.1.0'
    pod 'Gloss', '~> 2.0'
    pod 'MdsKit', :git => 'https://bitbucket.org/medvedstudio/mds.mobile.ios.git' # :path => '../Libraries.MdsKit/' #:git => 'https://ShumAlex@bitbucket.org/medvedstudio/ios-kit.git'
end

workspace 'Restomania.xcworkspace'

target 'Kuzina' do
    project './CoreFrameworkApp/CoreFrameworkApp.xcodeproj'
    shared
end

target 'CoreFramework' do
    project './CoreFramework/CoreFramework.xcodeproj'
    shared
end

post_install do |installer|
    sharedLibrary = installer.aggregate_targets.find { |aggregate_target| aggregate_target.name == 'Pods-CoreFramework' }
    installer.aggregate_targets.each do |aggregate_target|
        if aggregate_target.name == 'Pods-Kuzina'
            aggregate_target.xcconfigs.each do |config_name, config_file|
                sharedLibraryPodTargets = sharedLibrary.pod_targets
                aggregate_target.pod_targets.select { |pod_target| sharedLibraryPodTargets.include?(pod_target) }.each do |pod_target|
                    pod_target.specs.each do |spec|
                        frameworkPaths = unless spec.attributes_hash['ios'].nil? then spec.attributes_hash['ios']['vendored_frameworks'] else spec.attributes_hash['vendored_frameworks'] end || Set.new
                    frameworkNames = Array(frameworkPaths).map(&:to_s).map do |filename|
                        extension = File.extname filename
                        File.basename filename, extension
                    end
                    frameworkNames.each do |name|
                        puts "Removing #{name} from OTHER_LDFLAGS"
                        config_file.frameworks.delete(name)
                    end
                end
            end
            xcconfig_path = aggregate_target.xcconfig_path(config_name)
            config_file.save_as(xcconfig_path)
        end
    end
end
end
