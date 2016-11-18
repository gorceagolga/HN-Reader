//
//  ModelController.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "ModelController.h"
#import <AFNetworking.h>
#import "StoriesFetchRequest.h"
#import "StoriesDataFetcher.h"
#import "Story.h"
#import "NSArray+StorySort.h"

NSString *const errorMessageString = @"Could not load top stories.";

int const maxLimit = 10;

@interface ModelController () <ReloadDataProtocol>

@property (nonatomic, strong) StoriesDataFetcher *fetcher;
@property (nonatomic, strong) NSArray *idsArray;
@property (nonatomic, strong) NSMutableArray *fetchedStoriesArray;
@property (nonatomic, weak) id<ReloadDataProtocol> delegate;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) StoriesFetchRequest *request;

@end

@implementation ModelController

#pragma mark - Setters

- (void)setDelegate:(id<ReloadDataProtocol>)delegate {
    _delegate = delegate;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self startWorking];

    }
    return self;
}

- (NSMutableArray *)fetchedStoriesArray {
    if (!_fetchedStoriesArray) {
        _fetchedStoriesArray = [NSMutableArray array];
    }
    return _fetchedStoriesArray;
}

- (StoriesDataFetcher *)fetcher {
    if (!_fetcher) {
        _fetcher = [[StoriesDataFetcher alloc] init];
        [_fetcher setDelegate:self];
    }
    return _fetcher;
}

- (StoriesFetchRequest *)request {
    if (!_request) {
        _request = [[StoriesFetchRequest alloc] init];
    }
    return _request;
}

#pragma mark - Public methods


- (void)fetchNextPage {
    if (self.isLoading || !self.idsArray.count) {
        return;
    }

    NSMutableArray *fetchIDs = [NSMutableArray array];
    Story *story = [self.fetchedStoriesArray lastObject];
    long limit = [self getpageLimitFromStory:story];
    if (limit == 0) {
        return;
    }
    long start = [self getStartIndex:story];

    for (long i = start; i <= limit; i++) {
        [fetchIDs addObject:self.idsArray[i]];
    }

    self.isLoading = YES;

    [self.request setIDsToFetch:fetchIDs];
    [self.fetcher fetchNextPageRequest:self.request];

}

#pragma mark - Protected methods

- (void)getFirstPageSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    if (self.idsArray.count || self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [self.fetcher startFetchingStroiesSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        self.isLoading = NO;
        self.idsArray = responseObject;
        if (success) {
            [self fetchNextPage];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isLoading = NO;
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - Private methods

- (void)startWorking {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [self.delegate recievedError:errorMessageString];
        } else {
            [self resumeLoadingData];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void)resumeLoadingData {
    if (!self.idsArray) {
        [self getFirstPageSuccess:^(id responseObject) {
            [self fetchNextPage];
        } failure:^(NSError *error) {
            [self.delegate recievedError:error.localizedDescription];
        }];
    } else {
        [self fetchNextPage];
    }
}

- (long)getStartIndex:(Story *)story {
    if ([self.idsArray containsObject:story.uniqueID]) {
        return [self.idsArray indexOfObject:story.uniqueID] + 1;
    } else {
        return 0;
    }
}

- (long)getpageLimitFromStory:(Story *)story {
    long limit = 0;
    if (story) {
        long lastStoryIndex = [self.idsArray indexOfObject:story.uniqueID];
        if (lastStoryIndex == [self.idsArray count]-1) {

        } else if (lastStoryIndex >= [self.idsArray count]-maxLimit) {
            limit = self.idsArray.count-1;
        } else {
            limit = lastStoryIndex + maxLimit;
        }
    } else {
        limit = maxLimit;
    }
    return limit;
}

#pragma mark - ReloadDataProtocol

- (void)dataLoaded:(NSArray *)data {
    
    NSMutableArray *newStoriesArray = [NSMutableArray array];
    for (NSDictionary *storyData in data) {
        Story *story = [[Story alloc] initWithDictionary:storyData];
        [newStoriesArray addObject:story];
    }
    newStoriesArray = [[newStoriesArray sortedArrayUsingArray:self.request.idsToFetchArary] mutableCopy];
    [self.fetchedStoriesArray addObjectsFromArray:newStoriesArray];
    self.isLoading = NO;
    [self.delegate dataLoaded:(self.fetchedStoriesArray)];

}


@end
