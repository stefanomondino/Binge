//
//  Logger.swift
//  App
//
//  Created by Stefano Mondino on 17/07/18.
//  Copyright © 2018 Synesthesia. All rights reserved.
//

import Foundation

public final class ConsoleLogger: LoggerType {
    public init(logLevel: Logger.Level) {
        self.logLevel = logLevel
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-YYYY HH:mm:ss.sss"
        return formatter
    }()

    public let logLevel: Logger.Level
    public var isEnabled: Bool = true
    public func log(_ message: Any, level: Logger.Level = .error, tag: String? = nil) {
        guard
            isEnabled,
            logLevel != .none,
            level != .none,
            level.rawValue >= logLevel.rawValue else { return }
        let date = dateFormatter.string(from: Date())
        let description = String(describing: message)
        let string =
            """
            \([
                [date, tag].compactMap { $0 }.joined(separator: " "),
                description].compactMap { $0 }.joined(separator: " ")
            )
            """
        print(string)
    }
}
