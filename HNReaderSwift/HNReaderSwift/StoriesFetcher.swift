//
//  StoriesFetcher.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import UIKit
import Alamofire

class StoriesFetcher: NSObject {

    private(set) var fetchedStories: Array<Any>? = Array<Any>()

    private(set) lazy var operationQueue: OperationQueue = {
        var tempOperationQueue = OperationQueue()
        tempOperationQueue.maxConcurrentOperationCount = 10
        return tempOperationQueue
    }()

    var delegate: DataLoadedProtocol?

    public func fetchStoriesList(success: @escaping (DataResponse<Any>) -> Void, failure: @escaping (Error) -> Void) {
        Alamofire.request(GetRouter.getList()).responseJSON { (response) in
            if response.result.error == nil {
                success(response)
            } else {
                failure(response.result.error!)
            }
        }
    }

    public func fetchNextPage(request: StoriesFetchRequest) {

        fetchedStories?.removeAll()
        
        var operationsCout = 0
        var previousOperation: Operation?
        for urlString in request.itemsPathsToFetchArray {
            let operation = AlamofireOperation.init(URLString: urlString, networkOperationCompletionHandler: { (response, error) in
                operationsCout += 1
                if (error == nil) {
                    self.fetchedStories?.append(response!)
                }
                if operationsCout == request.itemsIDsToFetchArray?.count {
                    self.delegate!.dataLoaded(data: self.fetchedStories!);
                }
            })
            if previousOperation != nil {
                operation.addDependency(previousOperation!)
            }
            previousOperation = operation
            operationQueue.addOperation(operation)
        }
    }

}
