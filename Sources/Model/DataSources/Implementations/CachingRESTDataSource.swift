//
//  CachingRESTDataSource.swift
//  Model
//
//  Created by Stefano Mondino on 11/07/2020.
//

import Foundation
import RxSwift

class CachingRESTDataSource: DefaultRESTDataSource {
    var temporaryDirectory: URL { FileManager.default.temporaryDirectory }
    private func url<Endpoint: TargetType>(for endpoint: Endpoint) -> URL? {
        guard let key = endpoint.cacheKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)?.md5 else { return nil }
        let url = temporaryDirectory.appendingPathComponent("cached_\(key)", isDirectory: false)
        return url
    }

    private func checkAndDeleteExpired<Endpoint: TargetType>(for endpoint: Endpoint) -> URL? {
        guard let url = url(for: endpoint) else { return nil }
        guard let attributes = try? FileManager.default.attributesOfItem(atPath: url.path),
            let creationDate = attributes[.creationDate] as? Date,
            Date().timeIntervalSince1970 - creationDate.timeIntervalSince1970 < endpoint.cacheTime
        else {
            try? FileManager.default.removeItem(at: url)
            return nil
        }
        return url
    }

    private func cachedValue<Endpoint: TargetType>(for endpoint: Endpoint) -> Response? {
        guard let url = checkAndDeleteExpired(for: endpoint),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        return Response(statusCode: 200, data: data)
    }

    private func storeValue<Endpoint: TargetType>(_ value: Response?, for endpoint: Endpoint) {
        guard let url = self.url(for: endpoint) else { return }
        try? FileManager.default.removeItem(at: url)
        if let data = value?.data {
            try? data.write(to: url)
        }
        return
    }

    override func response<Endpoint: TargetType>(at endpoint: Endpoint) -> Observable<Response> {
        Observable.deferred {
            let observable = super.response(at: endpoint)
                .do(onNext: { self.storeValue($0, for: endpoint) })
            if let cachedValue = self.cachedValue(for: endpoint) {
                Logger.log("Cached value retrieved for \(endpoint.cacheKey)", level: .verbose)
                return .just(cachedValue) // observable.startWith(cachedValue)
            } else {
                Logger.log("No Cached value found for \(endpoint.cacheKey)", level: .verbose)
                return observable
            }
        }.distinctUntilChanged { (response1, response2) -> Bool in
            response1.data == response2.data && response1.statusCode == response2.statusCode
        }
    }
}
