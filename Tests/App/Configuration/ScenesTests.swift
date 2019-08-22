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

class ScenesSpec: QuickSpec {
    
    override func spec() {
        describe("Every scene in the app with identifier") {
            context("when instantiated") {
                Identifiers.Scenes.allCases.forEach { scene in
                    it("should exists and not throw") {
                        let scene = scene.scene()
                        expect(scene).notTo(beNil())
                        expect { _ = scene?.view }.notTo(throwError())
                    }
                }
            }
        }
    }
}
