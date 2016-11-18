//
//  FetcherTests.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 17/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

@import Quick;
@import Nimble;
#import "StoriesDataFetcher.h"
#import "StoriesFetchRequest.h"

@interface StoriesFetcherTests : NSObject  <ReloadDataProtocol>

@property (nonatomic, weak) id<ReloadDataProtocol> delegate;
@property (nonatomic, assign) BOOL delegateCalled;

@end

@implementation StoriesFetcherTests

- (void)dataLoaded:(NSArray *)data {
    expect(data).notToWithDescription(beNil(), @"Delegate method called with no data");
    self.delegateCalled = YES;
}

@end

QuickSpecBegin(FetcherTests);

StoriesDataFetcher *fetcher = [[StoriesDataFetcher alloc] init];
StoriesFetchRequest *request = [[StoriesFetchRequest alloc] init];
StoriesFetcherTests *testDelegate = [[StoriesFetcherTests alloc] init];
fetcher.delegate = testDelegate;

it(@"Test fetching the list of stories", ^{

    waitUntilTimeout(4, ^(void (^done)(void)){
        [fetcher startFetchingStroiesSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            expect(responseObject).notToWithDescription(beNil(), @"Nil response");
            expect(((NSArray *)responseObject).count).notToWithDescription(equal(0), @"Response object count is 0, so nothing to fetch");
            [request setIDsToFetch:[responseObject subarrayWithRange:NSMakeRange(0, 10)]];
            done();
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            expect(error).toWithDescription(beAnInstanceOf([NSError class]), @"Recieved error is not an error");
            done();
        }];
    });
});

it(@"Test fetching a page os stories", ^{

    [fetcher fetchNextPageRequest:request];

    expect(testDelegate.delegateCalled).toEventuallyWithDescription(beTrue(), @"Delegate method wasn't called");

});



QuickSpecEnd
