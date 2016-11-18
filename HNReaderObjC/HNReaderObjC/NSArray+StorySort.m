//
//  NSArray+StorySort.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 14/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "NSArray+StorySort.h"
#import "Story.h"

@implementation NSArray (StorySort)

static NSInteger comparatorForSortingUsingArray(Story *object1, Story *object2, void *context)
{
    NSUInteger index1 = [(__bridge NSArray *)context indexOfObject:object1.uniqueID];
    NSUInteger index2 = [(__bridge NSArray *)context indexOfObject:object2.uniqueID];
    if (index1 < index2)
        return NSOrderedAscending;

    if (index1 > index2)
        return NSOrderedDescending;
    
    return [@(index1) compare:@(index2)];
}

- (NSArray *)sortedArrayUsingArray:(NSArray *)otherArray
{
    return [self sortedArrayUsingFunction:comparatorForSortingUsingArray context:(__bridge void * _Nullable)(otherArray)];
}

@end
