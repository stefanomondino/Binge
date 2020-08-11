//
//  CoreTests.swift
//  CoreTests
//
//  Created by Stefano Mondino on 27/07/2020.
//

@testable import Core
import Foundation
import Nimble
import Quick

class TimeIntervalUtilitiesSpec: QuickSpec {
    override func spec() {
        describe("Time interval conversion") {
            context("in seconds") {
                it("should properly convert") {
                    expect(1.seconds).to(equal(1))
                    expect(60.seconds).to(equal(60))
                    expect(120.seconds).to(equal(120))
                }
            }
            context("in minutes") {
                it("should properly convert") {
                    expect(0.5.minutes).to(equal(30))
                    expect(1.minutes).to(equal(60))
                    expect(60.minutes).to(equal(3600))
                    expect(120.minutes).to(equal(7200))
                }
            }
            context("in hours") {
                it("should properly convert") {
                    expect(1.hours).to(equal(3600))
                    expect(3.hours).to(equal(10800))
                    expect(0.5.hours).to(equal(1800))
                }
            }
            context("in days") {
                it("should properly convert") {
                    expect(1.days).to(equal(86400))
                    expect(3.days).to(equal(259_200))
                    expect(0.5.days).to(equal(12.hours))
                }
            }
        }
    }
}
