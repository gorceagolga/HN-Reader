//
//  ModelControllerTests.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import Quick
import Nimble
@testable import HNReaderSwift

class ModelControllerDelegateTest: DataLoadedProtocol {
    var somethingWithDelegateAsyncResult: Bool? = false
    var lastStory: Story?

    func loadingFailedWithError(errorDescription: String) {
        
    }

    func dataLoaded(data: Array<Any>) {

        expect(data).notTo(beNil(), description: "Returned data from fetcher is nil")
        let story = data.last as! Story
        expect(story.uniqueID).notTo(beNil(), description: "Unique ID of story is nil")
        expect(story).notTo(equal(self.lastStory), description: "Did not download a new page")
        expect(story.title).notTo(beNil(), description: "Title of story is nil")
        lastStory = data.last as? Story
        somethingWithDelegateAsyncResult = true
    }
    
}

class ModelControllerTests: QuickSpec {
    
    override func spec() {

        let modelController = ModelController()
        let spyDelegate = ModelControllerDelegateTest()
        modelController.delegate = spyDelegate

        beforeEach {
            spyDelegate.somethingWithDelegateAsyncResult = false
        }

        it ("Test starting the model controller") {
            waitUntil(timeout: 2) { done in
                modelController.loadFirstPage(success: { (success, error) in
                    if success {
                        done()
                    } else {
                        done()
                    }
                })
            }
            expect(spyDelegate.somethingWithDelegateAsyncResult).toEventually(beTrue())
        }

        context("Test consecutive page loading", {
            it ("Test second page") {
                waitUntil(timeout: 2) { done in
                    modelController.fetchNextPage()
                    done()
                }

                expect(spyDelegate.somethingWithDelegateAsyncResult).toEventually(beTrue())
            }

            it ("Test third page loading") {
                waitUntil(timeout: 2) { done in
                    modelController.fetchNextPage()
                    done()
                }

                expect(spyDelegate.somethingWithDelegateAsyncResult).toEventually(beTrue())
            }
        })
    }

}
