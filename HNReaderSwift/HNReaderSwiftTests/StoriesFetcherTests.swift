//
//  StoriesFetcherTests.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import Quick
import Nimble
@testable import HNReaderSwift

class FetcherDelegateTest: DataLoadedProtocol {
    var somethingWithDelegateAsyncResult: Bool? = .none

    func loadingFailedWithError(errorDescription: String) {
        
    }

    func dataLoaded(data: Array<Any>) {

        expect(data).notTo(beNil(), description: "Returned data from fetcher is nil")
        somethingWithDelegateAsyncResult = true
    }

}

class StoriesFetcherTests: QuickSpec {

     let fetcher = StoriesFetcher();

    override func spec() {
        let testFetchRequest = StoriesFetchRequest()
        let spyDelegate = FetcherDelegateTest()
        self.fetcher.delegate = spyDelegate

        it("Test fetching the list of stories") {
            waitUntil(timeout: 4) { done in
                self.fetcher.fetchStoriesList(success: { (response) in
                    
                    expect(response).notTo(beNil(), description: "Non nil response")

                    let array = try! JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions(rawValue: UInt(0))) as! Array<NSNumber>

                    testFetchRequest.setItemsIDsToFetch(itemsIDsArray: Array(array.prefix(10)))

                    done()

                }, failure: { (error) in

                    print(error.localizedDescription)
                    expect(error).to(beAnInstanceOf(Error.self))

                    done()

                })
            }
        }
        
        it("Test fetching a page os stories") {

            self.fetcher.fetchNextPage(request: testFetchRequest)

            expect(spyDelegate.somethingWithDelegateAsyncResult).toEventually(beTrue())

        }
    }


}


