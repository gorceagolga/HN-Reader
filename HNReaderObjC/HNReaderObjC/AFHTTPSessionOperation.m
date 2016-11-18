//
//  AFHTTPSessionOperation.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "AFHTTPSessionOperation.h"
#import "AFNetworking.h"

@interface AFHTTPSessionOperation ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong, readwrite, nullable) NSURLSessionTask *task;

@end

@implementation AFHTTPSessionOperation

+ (instancetype)dataOperationWithManager:(AFHTTPSessionManager *)manager HTTPMethod:(NSString *)method completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    AFHTTPSessionOperation *operation = [[AFHTTPSessionOperation alloc] init];

    operation.task = [manager GET:method parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completionHandler(task.response, responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(task.response, nil, error);
    }];
    return operation;
}

@end
