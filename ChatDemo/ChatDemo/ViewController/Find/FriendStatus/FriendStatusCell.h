//
//  FriendStatusCell.h
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendStatusBean.h"

extern NSString *const kNSNotificationNameForLikeOrCommentView;

typedef void (^ReturnClickLabelBlock)(id indexPath);
typedef void (^ReturnTableViewCellBlock)(NSIndexPath *indexPath);

@interface FriendStatusCell : UITableViewCell

+ (CGFloat) calocCellHeightWithFriendStatus:(FriendStatusBean *) friendStatusBean;

- (void) dismissMenuSilderView;
- (void) setFriendStatus:(FriendStatusBean *) friendStatusBean;

@property (copy,nonatomic) ReturnClickLabelBlock returnClickLabelBlock;
@property (copy,nonatomic) ReturnTableViewCellBlock returnTableViewCellBlock;
@property (strong,nonatomic) NSIndexPath *indexPath;

@end
