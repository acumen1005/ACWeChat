//
//  CommonRefreshView.h
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCommonRefreshViewObserveKeyPath;


typedef NS_ENUM(NSInteger,CommonRefreshViewState){
    CommonRefreshViewStateNormal = 0,
    CommonRefreshViewStateWillRefresh = 1,
    CommonRefreshViewStateDidRefresh = 2,
};

@interface CommonRefreshView : UIView

@property (strong, nonatomic) UIScrollView *scrollView;

- (void) endRefreshing;

//@property (assign, nonatomic) UIEdgeInsets scrollViewOriginalInsets;
@property (assign, nonatomic) CommonRefreshViewState refreshState;

@end
