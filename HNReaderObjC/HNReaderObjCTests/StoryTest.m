//
//  HNReaderObjCTests.m
//  HNReaderObjCTests
//
//  Created by Gorceag Olga on 16/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "Story.h"
@import Quick;
@import Nimble;

QuickSpecBegin(StoryTests);

    Story *aStory = [[Story alloc] initWithDictionary:(@{
                                               @"by" : @"dhouston",
                                               @"descendants" : @71,
                                               @"id" : @8863,
                                               @"kids" : @[ @8952, @9224, @8917, @8884, @8887, @8943, @8869, @8958, @9005, @9671, @8940, @9067, @8908, @9055],
                                               @"score" : @111,
                                               @"time" : @1175714200,
                                               @"title" : @"My YC app: Dropbox - Throw away your USB drive",
                                               @"type" : @"story",
                                              @ "url" : @"http://www.getdropbox.com/u/2/screencast.html"
                                               })];

    it(@"Converts from JSON to Story object", ^{
        expect(aStory.author).to(equal(@"dhouston"));
        expect(aStory.commentsCount).to(equal(@71));
        expect(aStory.uniqueID).to(equal(@8863));
        expect(aStory.score).to(equal(@111));
        expect(aStory.timeStamp).to(equal(@1175714200));
        expect(aStory.link).to(equal(@"http://www.getdropbox.com/u/2/screencast.html"));
    });


QuickSpecEnd;
