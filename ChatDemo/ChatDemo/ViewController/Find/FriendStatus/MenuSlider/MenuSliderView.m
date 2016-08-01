//
//  MenuSliderView.m
//  ChatDemo
//
//  Created by acumen on 16/8/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "MenuSliderView.h"

#define SLIDER_WIDTH 100.0

@implementation MenuSliderView{
    
    UIButton *_likeButton;
    UIButton *_commentButton;
    BOOL _show;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup {
    
    [self setBackgroundColor:COLOR_RGBA(76, 81, 84, 1.0)];
    _show = NO;
}

#pragma mark - getter

- (BOOL) show {
    return _show;
}

#pragma mark - setter

- (void) setShow:(BOOL) show {
    
    _show = show;
    
    [UIView animateWithDuration:0.2 animations:^{
        if (!show) {
            [self setWidth:0.0];
        } else {
            [self setWidth:100.0];
        }
        [self.superview layoutIfNeeded];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
