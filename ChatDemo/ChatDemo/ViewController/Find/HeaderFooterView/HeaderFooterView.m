//
//  HeaderFooterView.m
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "HeaderFooterView.h"

@implementation HeaderFooterView


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUserInteractionEnabled:NO];
        [self setBackgroundView:[[UIView alloc] init]];
    }
    return self;
}

@end
