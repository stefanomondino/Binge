//
//  App+Configuration.swift
//  App
//
//  Created by Stefano Mondino on 09/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation

enum Environment: Bootstrappable {
    
    private struct Configuration {
        fileprivate static var environment: Environment!
        fileprivate static var vocabulary: [String: String] = [:]
    }

    case devel
    case prod
    
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    static var current: Environment {
        return Configuration.environment
    }
    
    static func bootstrap() {
        #if PROD
        Configuration.environment = Environment.prod
        #else
        Configuration.environment = Environment.devel
        #endif
        self.initVocabulary()
        ModelEnvironment.bootstrap()
        ViewModelEnvironment.bootstrap()
        switch Environment.current {
        case .devel: Logger.logLevel = .verbose
        case .prod: Logger.logLevel = .none
        }
    }
    
    var vocabulary: [String: String] {
        return Configuration.vocabulary
    }
    
    fileprivate static func initVocabulary() {
        
        Configuration.vocabulary = [:]
        
        guard let filePath = Bundle.main.url(forResource: "Translations", withExtension: "json") else {
            return
        }
        
        do {
            if try filePath.checkResourceIsReachable() {
                
                let data = try Data.init(contentsOf: filePath, options: .mappedIfSafe)
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
                    Logger.log("Vocabulary found: \(json)", level: .verbose)
                    Configuration.vocabulary = json
                } else {
                    Logger.log("Unable to read vocabulary. Please check json syntax at \(filePath)", level: .error)
                }
                
            }
        } catch {
            Logger.log("Unable to read vocabulary. Please check file at \(filePath)", level: .error)
        }
    }
}
