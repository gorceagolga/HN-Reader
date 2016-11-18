//
//  AFSessionOperation.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionOperation : NSOperation

@property (nonatomic, strong, readonly, nullable) NSURLSessionTask *task;

+ (instancetype)dataOperationWithManager:(AFHTTPSessionManager *)manager HTTPMethod:(NSString *)method completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
