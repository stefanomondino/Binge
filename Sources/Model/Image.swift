import Foundation
import RxSwift
//import RxCocoa
import AlamofireImage
import Boomerang

struct ImageDownloader {
    
    private static let downloader = {
        // AlamofireImage's downloader
        return AlamofireImage.ImageDownloader()
    }()
    
    static func  download(_ url: URL) -> Observable<Image> {
        return Observable<Image>.create { observer in
            let urlRequest = URLRequest(url: url)
            let start = Date()
            let receipt = downloader.download(urlRequest) { response in
                
                if let error =  response.error {
                    observer.onError(error)
                }
                
                let image = response.value ?? Image()
                image.downloadTime = Date().timeIntervalSince(start)
                observer.onNext(image)
                observer.onCompleted()
            }
            return Disposables.create {
                if let receipt = receipt {
                    downloader.cancelRequest(with: receipt)
                }
            }
            }
            .retryWhen { error in
                Reachability.rx.status.filter { $0.isReachable }
        }
    }
    
}
private struct AssociatedKeys {
    static var downloadtime = "imageDownloader_downloadtime"
}
extension Image {
    /// How long must take an image to be available in order to be considered "downloaded"
    var downloadTimeThreshold: TimeInterval { return 0.2 }
    
    ///Total amount of time that took this image to be "downloaded"
    /// This is useful to decide if, in the UI, an image should fade-in when presented or not
    /// Defaults to 0.0
    public fileprivate(set) var downloadTime: TimeInterval {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.downloadtime) as? TimeInterval ?? 0.0 }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.downloadtime, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    /// Defaults to false
    public var isDownloaded: Bool {
        return downloadTime > downloadTimeThreshold
    }
}

public protocol WithImage {
    func getImage() -> ObservableImage
    func getImage(with placeholder: WithImage?) -> ObservableImage
}
extension WithImage {
    public func getImage() -> ObservableImage {
        return getImage(with: nil)
    }
}
public typealias ObservableImage = Observable<Image>

extension Image: WithImage {
    
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return .just(self)
    }
}

extension URL: WithImage {
    
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return ImageDownloader.download(self)
            .catchError { _ in return (placeholder ?? "")
                .getImage()
                .asObservable()
        }
    }
}
extension String: WithImage {
    
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        if let url = URL(string: self),
            let scheme = url.scheme,
            ["http", "https"].contains(scheme) {
            return url.getImage(with: placeholder)
        }
        guard let img = Image(named: self) else {
            return placeholder?.getImage() ?? .just(Image())}
        return .just(img)
    }
    
    public func generateQRCode(with size: CGSize) -> Image? {
        let data = self.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("M", forKey: "inputCorrectionLevel")
            
            if let output = filter.outputImage {
                let scaleX = size.width / output.extent.size.width
                let scaleY = size.height / output.extent.size.height
                let transformedImage = output.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                return Image(ciImage: transformedImage)
            }
        }
        return nil
    }
}
