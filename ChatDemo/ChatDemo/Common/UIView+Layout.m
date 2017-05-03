//
//  UIView+Layout.m
//  ChatDemo
//
//  Created by acumen on 17/3/28.
//  Copyright © 2017年 acumen. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (void)removeAllSubViews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
