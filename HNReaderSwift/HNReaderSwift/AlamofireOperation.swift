//
//  AlamofireOperation.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireOperation: Operation {

    let URLString: String
    let networkOperationCompletionHandler: (_ responseObject: Any?, _ error: Error?) -> ()

    weak var request: Alamofire.Request?

    init(URLString: String, networkOperationCompletionHandler: @escaping (_ responseObject: Any?, _ error: Error?) -> ()) {
        self.URLString = URLString
        self.networkOperationCompletionHandler = networkOperationCompletionHandler
        super.init()
    }

    override func main() {
        request = Alamofire.request(GetRouter.getItem(URLString))
            .responseJSON { response in

                self.networkOperationCompletionHandler(response.result.value, response.result.error)

        }
    }
}

