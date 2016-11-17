//
//  ModelController.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import Foundation
import Alamofire

protocol DataLoadedProtocol {

    func dataLoaded(data: Array<Any>)

    func loadingFailedWithError(errorDescription: String)
    
}

class ModelController: NSObject {

    private let maxLimit = 10
    private let manager = NetworkReachabilityManager(host: "www.apple.com")

    var isLoading: Bool = false

    var delegate: DataLoadedProtocol?

    lazy var fetchedStoriesArray: Array<Story> = Array<Story>()

    private var idsArray: Array<NSNumber>!
    private(set) lazy var fetchRequest: StoriesFetchRequest = StoriesFetchRequest()
    private(set) lazy var dataFetcher: StoriesFetcher = {
        let tempFetcher = StoriesFetcher();
        tempFetcher.delegate = self;
        return tempFetcher
    }()

    // MARK: Init

    override init() {
        super.init()

        manager?.listener = { status in
            if (self.manager?.isReachable)! {
                self.startWorking()
            } else {
                self.delegate?.loadingFailedWithError(errorDescription: "No network reachability")
            }
        }
        manager?.startListening()
    }

    // MARK: Public Methods 

    func loadFirstPage(success: @escaping (Bool, Error?) -> Void) {
        if idsArray != nil{
            return;
        }
        dataFetcher.fetchStoriesList(success: { (response) in

            self.idsArray = try! JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions(rawValue: UInt(0))) as! Array<NSNumber>

            self.fetchNextPage()

            success(true, nil)

        }, failure: {(error) in

            success(false, error)
            
        })
    }

    func fetchNextPage() {
        if self.isLoading || idsArray == nil || self.idsArray.count == 0 {
            return;
        }

        let story: Story? = fetchedStoriesArray.last

        let limit = getpageLimitFromStory(story: story)

        if limit == 0 {
            return
        }

        let start = getStartIndex(story: story)

        let fetchIDs = Array(idsArray[start...limit])

        isLoading = true

        fetchRequest.setItemsIDsToFetch(itemsIDsArray: fetchIDs)
        dataFetcher.fetchNextPage(request: fetchRequest)
        
    }

    // MARR: Private methods

    private func startWorking() {
        if idsArray == nil {
            loadFirstPage { (success, error) in
                if !success {
                    self.delegate?.loadingFailedWithError(errorDescription: (error?.localizedDescription)! as String)
                }
            }
        } else {
            self.fetchNextPage()
        }
    }

    // MARK: Calculating the range for loading a new page

    private func getStartIndex(story: Story?) -> Int {
        if story != nil {
            return idsArray.index(of: (story?.uniqueID!)!)! + 1
        } else {
            return 0
        }
    }

    private func getpageLimitFromStory(story: Story?) -> Int {
        var limit: Int = 0
        if story != nil {
            let lastStoryIndex = idsArray.index(of: (story?.uniqueID!)!)

            if lastStoryIndex == (idsArray.count - 1) {

            } else if (lastStoryIndex)! >= (idsArray.count - maxLimit) {
                limit = idsArray.count - 1
            } else {
                limit = lastStoryIndex! + maxLimit
            }

        } else {
            limit = maxLimit
        }
        return limit
    }

}

// MARK: Data Loaded protocol

extension ModelController: DataLoadedProtocol {

    internal func loadingFailedWithError(errorDescription: String) {

    }

    func dataLoaded(data: Array<Any>) {

        var newStoriesArray = Array<Story>()
        for storyData in dataFetcher.fetchedStories! {
            let story: Story = Story.init(with: storyData as! NSDictionary)
            newStoriesArray.append(story)
        }

        newStoriesArray = newStoriesArray.sortedArrayUsingArray(anotherArray: fetchRequest.itemsIDsToFetchArray!) as! Array<Story>

        fetchedStoriesArray.append(contentsOf: newStoriesArray)

        self.isLoading = false

        self.delegate?.dataLoaded(data: fetchedStoriesArray)

    }
}
