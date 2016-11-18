//
//  StoriesDataFetcher.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "StoriesDataFetcher.h"
#import "HTTPClient.h"
#import "AFHTTPSessionOperation.h"
#import "AFNetworking.h"
#import "StoriesFetchRequest.h"

@interface StoriesDataFetcher ()

@property (nonatomic, strong) NSMutableArray *fetchedStories;
@property (nonatomic, strong) NSOperationQueue *fetchingIDsQueue;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, weak) id<ReloadDataProtocol> delegate;

@end

@implementation StoriesDataFetcher

#pragma mark - Setters

- (void)setDelegate:(id<ReloadDataProtocol>)delegate {
    _delegate = delegate;
}

#pragma mark - Getters

- (NSArray *)getStories {
    return self.fetchedStories;
}

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (NSOperationQueue *)fetchingIDsQueue {
    if (!_fetchingIDsQueue) {
        _fetchingIDsQueue = [[NSOperationQueue alloc] init];
        self.fetchingIDsQueue.maxConcurrentOperationCount = 1;
    }
    return _fetchingIDsQueue;
}

#pragma mark - Public methods

- (void)fetchNextPageRequest:(StoriesFetchRequest *)request {

    AFHTTPSessionManager *manager = [HTTPClient defaultClient];

    self.fetchedStories = [NSMutableArray array];

    __block int operationsCount = 0;

    NSOperation *previous;
    for (NSString *urlString in request.itemsPathsToFetch) {

        NSOperation *operation = [AFHTTPSessionOperation dataOperationWithManager:manager HTTPMethod:urlString completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            operationsCount += 1;

            if (!error) {
                [self.fetchedStories addObject:responseObject];

                if (operationsCount == request.idsToFetchArary.count) {
                    [self.delegate dataLoaded:self.fetchedStories];
                }

            }
        }];

        if (previous) {
            [operation addDependency:previous];
        }

        previous = operation;
        [self.fetchingIDsQueue addOperation:operation];

    }
}

- (void)startFetchingStroiesSuccess:(void (^)(NSURLSessionDataTask *, NSArray *))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [[HTTPClient defaultClient] GET:TopStoriesPath parameters:nil progress:nil success:success failure:failure];
}

@end
