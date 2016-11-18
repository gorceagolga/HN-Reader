//
//  UIScrollView+ScrollToBottom.h
//  HNReaderObjC
//
//  Created by Gorceag Olga on 17/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ScrollToBottom)

- (BOOL) scrolledToBottomWithBuffer:(CGPoint)contentOffset :(CGSize)contentSize :(UIEdgeInsets)contentInset :(CGRect)bounds;

@end
