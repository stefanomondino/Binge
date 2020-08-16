//
//  StringsFactory.swift
//  App
//
//  Created by Stefano Mondino on 02/12/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

class StringsFactory {
    fileprivate static var current: () -> StringsFactory? = { nil }
    init(container: RootContainer) {
        StringsFactory.current = { container.translations }
    }

    lazy var vocabulary: [String: Any] = {
        do {
            let bundle = Bundle(for: StringsFactory.self)
            guard let json = bundle.url(forResource: "Translations", withExtension: "json") else { return [:] }
            let data = try Data(contentsOf: json)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
        } catch {
            Logger.log(error, level: .error)
            return [:]
        }
    }()

    func translation(for string: Translation) -> String {
        return vocabulary.valueForKeyPath(keyPath: string.key) as? String ?? string.key
    }
}

extension Translation {
    var translation: String { StringsFactory.current()?.translation(for: self) ?? key }
}
