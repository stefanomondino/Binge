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
    init(container: AppDependencyContainer) {
        StringsFactory.current = { container.translations }
    }
    
    lazy var vocabulary: [String: String] = {
        do  {
            let bundle = Bundle(for: StringsFactory.self)
            guard let json = bundle.url(forResource: "Translations", withExtension: "json") else { return [:] }
            let data = try Data(contentsOf: json)
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }()
    
    func translation(for string: Translation) -> String {
        return vocabulary[string.key] ?? string.key
    }
}
extension Translation {
    var translation: String { StringsFactory.current()?.translation(for: self) ?? self.key }
}
