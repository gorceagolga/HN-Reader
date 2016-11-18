//
//  Story.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "Story.h"

NSString *const titleKey = @"title";
NSString *const scoreKey = @"score";
NSString *const timeKey = @"time";
NSString *const authorKey = @"by";
NSString *const commentsCountKey = @"descendants";
NSString *const linkKey = @"url";
NSString *const uniqueIDKey = @"id";

@interface Story ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSNumber *timeStamp;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *commentsCount;
@property (nonatomic, strong) NSNumber *uniqueID;

@end

@implementation Story

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.title = dictionary[titleKey];
        self.score = dictionary[scoreKey];
        self.timeStamp = dictionary[timeKey];
        self.author = dictionary[authorKey];
        self.commentsCount = dictionary[commentsCountKey];
        self.link = dictionary[linkKey];
        self.uniqueID = dictionary[uniqueIDKey];
    }
    return self;
}

@end
