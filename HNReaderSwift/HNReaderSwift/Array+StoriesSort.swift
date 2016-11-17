//
//  Array+StoriesSort.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import Foundation

extension Array {

    func sortedArrayUsingArray(anotherArray: Array<NSNumber>) -> Array<Any> {
        return self.sorted(by: { (obj1, obj2) -> Bool in

            let index1 = anotherArray.index(of: ((obj1 as! Story).uniqueID))
            let index2 = anotherArray.index(of: ((obj2 as! Story).uniqueID))

            if index1! < index2! {
                return true
            } else {
                return false
            }
        })
    }
}
