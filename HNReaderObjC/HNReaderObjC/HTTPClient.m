//
//  HTTPClient.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "HTTPClient.h"
#import "AFHTTPSessionOperation.h"

NSString *const BaseURL = @"https://hacker-news.firebaseio.com/";

@implementation HTTPClient

#pragma mark - Inititalization

+ (instancetype)defaultClient {
    static HTTPClient *client;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[HTTPClient alloc] initPrivate];
    });
    return client;
}

- (instancetype)init
{
    NSString *name = [NSString stringWithFormat:@"%@ is singleton.", NSStringFromClass([self class])];
    NSString *reason = @"Use + defaultClient to instantiate this class.";
    @throw [NSException exceptionWithName:name reason:reason userInfo:nil];
    return nil;
}

#pragma mark - Override

- (NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    if (!failure) { return nil; }
    return [super GET:URLString parameters:parameters success:success failure:failure];
}

#pragma mark - Private metods

- (instancetype)initPrivate {
    NSURL *baseURL = [NSURL URLWithString:BaseURL];
    self = [super initWithBaseURL:baseURL];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

@end
