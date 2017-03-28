//
//  FriendStatusRefreshHeaderView.m
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendStatusRefreshHeaderView.h"

static const CGFloat criticalY = -60.0f;

#define kFriendStatusRefreshHeaderRotateAnimationKey @"RotateAnimationKey"

@implementation FriendStatusRefreshHeaderView {
    CABasicAnimation *_rotateAnimation;
}

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center {
    FriendStatusRefreshHeaderView *header = [[FriendStatusRefreshHeaderView alloc]init];
    header.center = center;
    
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AlbumReflashIcon"]];
    self.bounds = imageView.bounds;
    [self addSubview:imageView];
    
    _rotateAnimation = [[CABasicAnimation alloc] init];
    _rotateAnimation.keyPath = @"transform.rotation.z";
    _rotateAnimation.fromValue = @0;
    _rotateAnimation.toValue = @(M_PI * 2);
    _rotateAnimation.duration = 1.0;
    _rotateAnimation.repeatCount = MAXFLOAT;
}

- (void)setRefreshState:(CommonRefreshViewState)refreshState {
    [super setRefreshState:refreshState];
    
    if (refreshState == CommonRefreshViewStateDidRefresh) {
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
        [self.layer addAnimation:_rotateAnimation forKey:kFriendStatusRefreshHeaderRotateAnimationKey];
    } else if (refreshState == CommonRefreshViewStateNormal) {
        [self.layer removeAnimationForKey:kFriendStatusRefreshHeaderRotateAnimationKey];
    
        [UIView animateWithDuration:0.3f animations:^{
            CGAffineTransform transform = CGAffineTransformIdentity;
            transform = CGAffineTransformTranslate(transform, 0, 0);
            self.transform = transform;
        }];
    }
}

- (void)updateRefreshHeaderWithOffsetY:(CGFloat)y {
    
    CGFloat rotateValue = y / 50.0 * M_PI;
    
    if (y < criticalY) {
        y = criticalY;
        
        if (self.scrollView.isDragging && self.refreshState != CommonRefreshViewStateWillRefresh) {
            self.refreshState = CommonRefreshViewStateWillRefresh;
        } else if (!self.scrollView.isDragging && self.refreshState == CommonRefreshViewStateWillRefresh) {
            self.refreshState = CommonRefreshViewStateDidRefresh;
        }
    }
    
    if (self.refreshState == CommonRefreshViewStateDidRefresh){
        return;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0, -y);
    transform = CGAffineTransformRotate(transform, rotateValue);
    
    self.transform = transform;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (keyPath != kCommonRefreshViewObserveKeyPath){
        return;
    }
    [self updateRefreshHeaderWithOffsetY:self.scrollView.contentOffset.y + 64];
}

@end
