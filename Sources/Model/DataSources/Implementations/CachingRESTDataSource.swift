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
        guard let key = endpoint.cacheKey.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else { return nil }
        let url = temporaryDirectory.appendingPathComponent("cached_\(key)", isDirectory: false)
        print(url)
        return url
    }

    private func cachedValue<Endpoint: TargetType>(for endpoint: Endpoint) -> Response? {
        guard let url = self.url(for: endpoint),
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
        let observable = super.response(at: endpoint)
            .do(onNext: { self.storeValue($0, for: endpoint) })
        if let cachedValue = cachedValue(for: endpoint) {
            return observable.startWith(cachedValue)
        } else {
            return observable
        }
    }
}
