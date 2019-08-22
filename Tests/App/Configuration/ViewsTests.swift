//
//  ScenesTests.swift
//  AppTests
//
//  Created by Stefano Mondino on 08/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Quick
import Nimble
import RxBlocking
import Boomerang
import ViewModel
@testable import App

class ViewsSpec: QuickSpec {
    
    override func spec() {
        describe("Every view in the app with identifier") {
            context("when instantiated") {
        Identifiers.Views.allCases.forEach { view in
                    it("should exists and not throw") {
                        let view = view.view()
                        expect(view).notTo(beNil())

                    }
                }
            }
        }
    }
}
