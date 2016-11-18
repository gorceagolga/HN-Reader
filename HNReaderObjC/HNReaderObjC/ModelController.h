//
//  ModelController.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReloadDataProtocol.h"


@interface ModelController : NSObject

- (void)setDelegate:(id<ReloadDataProtocol>)delegate;

- (void)fetchNextPage;

@property (nonatomic, assign, readonly) BOOL isLoading;

@end
