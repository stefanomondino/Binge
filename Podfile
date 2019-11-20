# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!
platform :ios, '12.0'

def ios_platform
  platform :ios, '12.0'
end

def shared_pods
  pod "Boomerang/RxSwift", :git => "https://github.com/stefanomondino/newark", :branch => "master"
  pod "Boomerang/UIKit", :git => "https://github.com/stefanomondino/newark", :branch => "master"
end

def model_pods
  shared_pods
  pod 'Alamofire'
  pod 'Moya/RxSwift', :git => "https://github.com/Moya/Moya",  :branch => "14.0.0-beta.5"
  pod 'AlamofireImage', :git => "https://github.com/Alamofire/AlamofireImage", :branch => "master"
  pod 'KeychainAccess'
  pod 'Gloss'
#MURRAY MODEL_PODS PLACEHOLDER
end

def app_pods
  pod 'Tabman'
  pod 'SnapKit'
  pod 'Hero'
  pod 'pop'
  pod 'SwiftRichString'
  pod 'SwiftLint'
  pod 'RxGesture'
  pod 'SkeletonView'
  pod 'PluginLayout', :git => "https://github.com/stefanomondino/PluginLayout", :branch => "master"
#MURRAY APP_PODS PLACEHOLDER
end

def ios_app_pods
  app_pods
#MURRAY IOS_APP_PODS PLACEHOLDER
end

def tvos_app_pods
  app_pods
#MURRAY TVOS_APP_PODS PLACEHOLDER
end

def test_pods
  inherit! :search_paths
  pod 'Quick'
  pod 'Nimble'
  pod 'RxBlocking'
#MURRAY TEST_PODS PLACEHOLDER
end

target 'Model' do
  model_pods
  target 'ModelTests' do
    test_pods
  end
end

target 'App' do
  ios_platform
  ios_app_pods
  target "AppTests" do
    test_pods
  end
end
