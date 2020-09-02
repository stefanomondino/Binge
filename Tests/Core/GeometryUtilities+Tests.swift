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

class GeometryUtilitiesSpec: QuickSpec {
    override func spec() {
        describe("A CGSize object") {
            context("when empty") {
                let size = CGSize.zero
                it("should have empty area") {
                    expect(size.area) == 0
                }
                it("should be empty") {
                    expect(size.isEmpty) == true
                }
                it("should have ratio equal to zero") {
                    expect(size.ratio) == 0
                }
            }
        }
    }
}
