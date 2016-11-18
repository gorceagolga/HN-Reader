//
//  HTTPClient.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface HTTPClient : AFHTTPSessionManager

+ (instancetype)defaultClient;

@end
