//
//  ScenesTests.swift
//  AppTests
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

@testable import Binge_iOS
import Boomerang
import Nimble
import Quick
import RxBlocking
//
class ViewsSpec: QuickSpec {
    override func spec() {
        describe("Every view in the app with identifier") {
            let factory = MainViewFactory()
            ViewIdentifier.allCases.forEach { id in
                context("ViewIdentifier.\(id)") {
                    it("should exists and not throw") {
                        let view = factory.view(from: id)
                        expect(view).notTo(beNil())
                    }
                }
            }
            GenericItemViewModel.Identifier.allCases.forEach { id in
                context("GenericItemViewModel.Identifier.\(id)") {
                    it("should exists and not throw") {
                        let view = factory.view(from: id)
                        expect(view).notTo(beNil())
                    }
                }
            }
        }
    }
}
