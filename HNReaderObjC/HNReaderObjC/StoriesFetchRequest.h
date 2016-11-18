//
//  StoriesFetchRequest.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BaseURL;
extern NSString *const TopStoriesPath;

@interface StoriesFetchRequest : NSObject

@property (nonatomic, strong, readonly) NSArray *itemsPathsToFetch;
@property (nonatomic, strong, readonly) NSArray *idsToFetchArary;

- (void)setIDsToFetch:(NSArray *)idsToFetch;

@end
