//
//  StoriesFetchRequest.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import UIKit

let ItemPath = "v0/item/%@.json"
let TopStoriesPath = "v0/topstories.json";

class StoriesFetchRequest: NSObject {

    private(set) var itemsPathsToFetchArray: Array<String> = Array()
    private(set) var itemsIDsToFetchArray: Array<NSNumber>?

    public func setItemsIDsToFetch(itemsIDsArray: Array<NSNumber>) {
        itemsPathsToFetchArray.removeAll()
        for number in itemsIDsArray {
            itemsPathsToFetchArray.append(String(format: ItemPath, number))
        }
        itemsIDsToFetchArray = itemsIDsArray
    }

}
