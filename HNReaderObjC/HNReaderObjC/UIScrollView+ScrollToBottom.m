//
//  UIScrollView+ScrollToBottom.m
//  HNReaderObjC
//
//  Created by Gorceag Olga on 17/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

#import "UIScrollView+ScrollToBottom.h"

@implementation UIScrollView (ScrollToBottom)

- (BOOL) scrolledToBottomWithBuffer:(CGPoint)contentOffset :(CGSize)contentSize :(UIEdgeInsets)contentInset :(CGRect)bounds {
    
    CGFloat buffer = CGRectGetHeight(bounds) - contentInset.top - contentInset.bottom;
    const CGFloat maxVisibleY = (contentOffset.y + bounds.size.height);
    const CGFloat actualMaxY = (contentSize.height + contentInset.bottom);
    return ((maxVisibleY + buffer) >= actualMaxY);
}

@end
