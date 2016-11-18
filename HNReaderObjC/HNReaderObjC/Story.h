//
//  Story.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Story : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSNumber *uniqueID;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *link;
@property (nonatomic, strong, readonly) NSString *author;
@property (nonatomic, strong, readonly) NSNumber *timeStamp;
@property (nonatomic, strong, readonly) NSNumber *score;
@property (nonatomic, strong, readonly) NSNumber *commentsCount;

@end
