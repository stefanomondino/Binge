# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!


ENV["APP_NAME"] = ENV["APP_NAME"] || "Binge"

def boomerang
  pod "Boomerang/RxSwift"
end

def model_pods
  boomerang
  pod 'RxRelay'
  pod 'Alamofire'
  pod 'Moya/RxSwift'
  pod 'Kingfisher'
  pod 'KeychainAccess'
  pod 'Gloss'
end

def app_pods
  model_pods
  pod 'SnapKit'
  pod 'SwiftRichString'
  pod 'RxCocoa'
  pod 'Charts'
  #pod 'PluginLayout', :git => "https://github.com/stefanomondino/PluginLayout.git", :branch => "master"
  #pod 'PluginLayout', :path => "../OpenSource/PluginLayout"
  pod 'PluginLayout'
end

def ios_pods
  pod 'RxGesture'
  pod 'Tabman'
end
def tvos_pods
  pod 'ParallaxView'
end

def test_pods
  inherit! :search_paths
  pod 'Quick'
  pod 'Nimble'
  pod 'RxBlocking'
  pod 'RxNimble'
end

def core_pods
  boomerang
end

target 'Core_iOS' do
  platform :ios, '12.0'
  core_pods
  target 'CoreTests' do
    test_pods
    core_pods
  end
end

target 'Core_tvOS' do
  platform :tvos, '12.0'
  boomerang
end

target 'Model_iOS' do
  platform :ios, '12.0'
  model_pods
  target 'ModelTests' do
    test_pods
    model_pods
  end
end
target 'Model_tvOS' do
  platform :tvos, '12.0'
  model_pods
end

target "#{ENV["APP_NAME"]}_iOS" do
  platform :ios, '12.0'
  app_pods
  ios_pods
  target "#{ENV["APP_NAME"]}Tests_iOS" do
    test_pods
  end
end

target "HostingApp" do
  platform :ios, '12.0'
  app_pods
  ios_pods
end


target "#{ENV["APP_NAME"]}_tvOS" do
  platform :tvos, '12.0'
  app_pods
  tvos_pods
  target "#{ENV["APP_NAME"]}Tests_tvOS" do
    test_pods
  end
end
