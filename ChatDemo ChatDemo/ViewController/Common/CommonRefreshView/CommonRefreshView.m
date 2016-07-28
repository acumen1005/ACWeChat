//
//  CommonRefreshView.m
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "CommonRefreshView.h"

NSString *const kCommonRefreshViewObserveKeyPath = @"contentOffset";

@implementation CommonRefreshView

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    
    //KVO
    [scrollView addObserver:self forKeyPath:kCommonRefreshViewObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:kCommonRefreshViewObserveKeyPath];
    }
}

- (void) endRefreshing {
    
    self.refreshState = CommonRefreshViewStateNormal;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
  
}

@end
