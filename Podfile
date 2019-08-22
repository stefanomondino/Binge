# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!
platform :ios, '11.0'

def ios_platform
  platform :ios, '11.0'
end

def shared_pods
  pod "Boomerang", :git => "https://github.com/synesthesia-it/Boomerang", :branch => "v5"
end

def model_pods
  shared_pods
  pod 'Alamofire'
  pod 'Moya/RxSwift', :git => "https://github.com/Moya/Moya",  :branch => "14.0.0-alpha.2"
  pod 'AlamofireImage', :git => "https://github.com/Alamofire/AlamofireImage", :branch => "master"
#  pod 'Cache'
  pod 'KeychainAccess'
  pod 'Gloss'
#MURRAY MODEL_PODS PLACEHOLDER
end

def viewmodel_pods
  model_pods
#MURRAY VIEWMODEL_PODS PLACEHOLDER
end

def app_pods
  viewmodel_pods
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

target 'ViewModel' do
  viewmodel_pods
  target 'ViewModelTests' do
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
