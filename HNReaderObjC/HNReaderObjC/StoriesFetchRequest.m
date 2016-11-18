//
//  StoriesFetchRequest.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "StoriesFetchRequest.h"

NSString *const ItemPath = @"v0/item/%@.json";
NSString *const TopStoriesPath = @"v0/topstories.json";

@interface StoriesFetchRequest ()

@property (nonatomic, strong) NSArray *itemsPathsToFetch;
@property (nonatomic, strong) NSArray *idsToFetchArary;

@end

@implementation StoriesFetchRequest

- (void)setIDsToFetch:(NSArray *)idsToFetch {
    NSMutableArray *pathsArray = [NSMutableArray array];
    for (NSNumber *number in idsToFetch) {
        [pathsArray addObject:[NSString stringWithFormat:ItemPath, number]];
    }
    self.itemsPathsToFetch = pathsArray;
    self.idsToFetchArary = idsToFetch;
}
@end
