import Core
import Foundation
import Kingfisher
import RxSwift

private struct ImageDownloader {
    private static let downloader: Kingfisher.KingfisherManager = {
        KingfisherManager.shared
    }()

    func download(_ url: URL) -> Observable<Core.Image> {
        return Observable<Core.Image>.create { observer in
            let start = Date()
            let task = ImageDownloader.downloader.retrieveImage(with: url) { result in
                switch result {
                case let .success(value):
                    let image = value.image
                    image.downloadTime = value.cacheType.cached ? 0 : Date().timeIntervalSince(start)
                    observer.onNext(image)
                    observer.onCompleted()
                case let .failure(error):

                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
        .retryWhen { _ in
            Reachability.rx.status.filter { $0.isReachable }
        }
    }
}

extension Core.Image: WithImage {
    public func getImage(with _: WithImage?) -> ObservableImage {
        return .just(self)
    }
}

extension URL: WithImage {
    public func getImage(with placeholder: WithImage?) -> ObservableImage {
        return ImageDownloader().download(self)
            .catchError { _ in (placeholder ?? "")
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
        guard let img = Core.Image(named: self) else {
            return placeholder?.getImage() ?? .just(Core.Image())
        }
        return .just(img)
    }
}
