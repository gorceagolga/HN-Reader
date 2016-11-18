//
//  ReloadDataProtocol.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 13/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

@protocol ReloadDataProtocol <NSObject>

@required
- (void)dataLoaded:(NSArray *)data;

@optional
- (void)recievedError:(NSString *)errordescription;

@end
