//
//  ModelControllerTest.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 18/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

@import Quick;
@import Nimble;

#import "ModelController.h"
#import "ModelController_Private.h"
#import "Story.h"

@interface ModelControllerDelegateTests : NSObject <ReloadDataProtocol>

@property (nonatomic, weak) id<ReloadDataProtocol> delegate;
@property (nonatomic, assign) BOOL dataLoaded;
@property (nonatomic, assign) BOOL errorRecieved;
@property (nonatomic, strong) Story *lastStory;

@end

@implementation ModelControllerDelegateTests

- (void)dataLoaded:(NSArray *)data {
    expect(data).notTo(beNil());
    Story *story = data.lastObject;
    expect(story.uniqueID).notTo(beNil());
    expect(story.title).notTo(beNil());
    expect(story).notTo(equal(self.lastStory));
    self.lastStory = story;
    self.dataLoaded = YES;
}

- (void)recievedError:(NSString *)errordescription {
    self.errorRecieved = YES;
}


@end

QuickSpecBegin(ModelControllerTest);

__block ModelController *modelController;
ModelControllerDelegateTests *testDelegate = [[ModelControllerDelegateTests alloc] init];


beforeEach(^{
    testDelegate.dataLoaded = NO;
    testDelegate.errorRecieved = NO;
});

it(@"Start testing model controller", ^{
    waitUntilTimeout(6, ^(void (^done)(void)){
        modelController = [[ModelController alloc] init];
        modelController.delegate = testDelegate;
        done();
    });
    expect(testDelegate.dataLoaded).toEventually(beTrue());
});

context(@"Test consecutive page loading", ^{
    it(@"Test second page", ^{
        waitUntilTimeout(2, ^(void (^done)(void)){
            [modelController fetchNextPage];
            done();
        });
        expect(testDelegate.dataLoaded).toEventually(beTrue());
    });

    it(@"Test third page", ^{
        waitUntilTimeout(2, ^(void (^done)(void)){
            [modelController fetchNextPage];
            done();
        });
        expect(testDelegate.dataLoaded).toEventually(beTrue());
    });
});

QuickSpecEnd;
