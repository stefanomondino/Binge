//
//  TimeInterval+Conversion.swift
//  Core
//
//  Created by Stefano Mondino on 11/08/2020.
//

import Foundation

public extension TimeInterval {
    var seconds: TimeInterval {
        self
    }

    var minutes: TimeInterval {
        seconds * 60
    }

    var hours: TimeInterval {
        minutes * 60
    }

    var days: TimeInterval {
        hours * 24
    }
}

// public extension Int {
//    var seconds: TimeInterval {
//        TimeInterval(self).seconds
//    }
//    var hours: TimeInterval {
//        TimeInterval(self).hours
//    }
//    var minutes: TimeInterval {
//        TimeInterval(self).minutes
//    }
//    var days: TimeInterval {
//        TimeInterval(self).days
//    }
// }
