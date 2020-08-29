//
//  LocalUserPropertyDataSource.swift
//  Binge
//
//  Created by Stefano Mondino on 29/08/2020.
//

import Foundation

class LocalUserPropertyDataSource: UserPropertyDataSource {
    @UserDefaultsBacked(key: "selectedThemeId", defaultValue: "") var selectedThemeId: String
}

extension LocalUserPropertyDataSource {
    @propertyWrapper struct UserDefaultsBacked<Value> {
        let key: String
        let defaultValue: Value
        var storage: UserDefaults = .standard

        var wrappedValue: Value {
            get {
                let value = storage.value(forKey: key) as? Value
                return value ?? defaultValue
            }
            set {
                storage.setValue(newValue, forKey: key)
            }
        }
    }
}
