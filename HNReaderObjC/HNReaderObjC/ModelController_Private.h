//
//  ModelController_Private.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 18/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "ModelController.h"

@interface ModelController()

- (void)getFirstPageSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end
