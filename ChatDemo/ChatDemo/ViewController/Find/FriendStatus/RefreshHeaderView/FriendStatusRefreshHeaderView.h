//
//  FriendStatusRefreshHeaderView.h
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "CommonRefreshView.h"

@interface FriendStatusRefreshHeaderView : CommonRefreshView

+ (instancetype)refreshHeaderWithCenter:(CGPoint)center;
@property (nonatomic, copy) void(^refreshingBlock)();

@end
