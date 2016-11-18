//
//  StoriesDataFetcher.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReloadDataProtocol.h"

@class StoriesFetchRequest;

@interface StoriesDataFetcher : NSObject

- (void)setDelegate:(id<ReloadDataProtocol>)delegate;

- (void)startFetchingStroiesSuccess:(void (^)(NSURLSessionDataTask *task, NSArray* responseObject))success failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)fetchNextPageRequest:(StoriesFetchRequest *)request;

- (NSArray *)getStories;

@end
