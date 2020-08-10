//
//  AccessToken.swift
//  Model
//
//  Created by Stefano Mondino on 20/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import KeychainAccess

struct AccessToken: Codable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let scope: String
    let expiresIn: Int
}

extension AccessToken {
    static var current: AccessToken? {
        get {
            let keychain = Keychain()
            guard let data = keychain[data: "accessToken"] else {
                Logger.log("No access token found", level: .verbose)
                return nil
            }
            do {
                let token = try JSONDecoder().decode(AccessToken.self, from: data)
                Logger.log("Found access token in keychain: \(token)", level: .verbose)
                return token
            } catch {
                Logger.log("No access token found", level: .verbose)
                return nil
            }
        }
        set {
            let keychain = Keychain()
            let data = try? JSONEncoder().encode(newValue)
            keychain[data: "accessToken"] = data
        }
    }
}
