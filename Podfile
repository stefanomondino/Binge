# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!
platform :ios, '12.0'

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
  pod 'Tabman'
  pod 'SnapKit'
  pod 'SwiftRichString'
  pod 'RxCocoa'
  pod 'RxGesture'
end

def test_pods
  inherit! :search_paths
  pod 'Quick'
  pod 'Nimble'
  pod 'RxBlocking'
  pod 'RxNimble'
end

target 'Core' do
  boomerang
  target 'CoreTests' do
    test_pods
  end
end

target 'Model' do
  model_pods
  target 'ModelTests' do
    test_pods
  end
end

target ENV["APP_NAME"] do
  app_pods
  target "#{ENV["APP_NAME"]}Tests" do
    test_pods
  end
end
