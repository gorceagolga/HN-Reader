//
//  Story.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import UIKit

class Story: NSObject {

    let titleKey = "title"
    let scoreKey = "score"
    let timeKey = "time"
    let authorKey = "by"
    let commentsCountKey = "descendants"
    let linkKey = "url"
    let uniqueIDKey = "id"

    var uniqueID: NSNumber!
    var title: String!
    var link: String!
    var author: String!
    var timeStamp: NSNumber!
    var score: NSNumber!
    var commentsCount: NSNumber!

    override init() {
        super.init()
    }

    convenience init(with data:NSDictionary) {
        self.init()
        uniqueID = data[uniqueIDKey] as! NSNumber
        title = data[titleKey] as! String
        score = data[scoreKey] as! NSNumber
        link = data[linkKey] as? String
        author = data[authorKey] as! String
        timeStamp = data[timeKey] as! NSNumber
        commentsCount = data[commentsCountKey] as? NSNumber
    }

}
