//
//  Logger.swift
//  Core
//
//  Created by Stefano Mondino on 13/07/2020.
//

import Boomerang
import Foundation

public protocol LoggerType {
    func log(_ message: Any, level: Logger.Level, tag: String?)
}

public class Logger {
    public enum Tag: String, CustomStringConvertible {
        case none
        case lifecycle
        case api
        public var description: String {
            "[\(rawValue.uppercased())]"
        }
    }

    public enum Level: Int {
        case useless = 0
        case verbose = 1
        case warning = 10
        case network = 20
        case debug = 50
        case error = 100
        case none = 1000
    }

    private var loggers: [LoggerType] = []

    public static let shared: Logger = Logger()

    public init() {}

    public func add(logger: LoggerType) {
        loggers.append(logger)
    }

    public static func log(_ message: Any, level: Level = .verbose, tag: Tag) {
        shared.log(message, level: level, tag: tag.description)
    }

    public static func log(_ message: Any, level: Level = .verbose, tag: String? = nil) {
        shared.log(message, level: level, tag: tag)
    }

    public func log(_ message: Any, level: Level = .verbose, tag: Tag = .none) {
        log(message, level: level, tag: tag.description)
    }

    public func log(_ message: Any, level: Level = .verbose, tag: String? = nil) {
        loggers.forEach {
            $0.log(message, level: level, tag: tag)
        }
    }
}
