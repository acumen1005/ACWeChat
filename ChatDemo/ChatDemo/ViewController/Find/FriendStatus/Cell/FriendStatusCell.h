//
//  FriendStatusCell.h
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendStatusBean.h"

@protocol FriendStatusCellDelegate <NSObject>

- (void)tableViewCell:(UITableViewCell *)friendStatusCell
didClickLikeAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewCell:(UITableViewCell *)friendStatusCell
dismissLikeAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewCell:(UITableViewCell *)friendStatusCell
didClickCommentAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewCell:(UITableViewCell *)friendStatusCell
didClickNameAtIndexPath:(NSIndexPath *)indexPath;

- (void)onClickToPushUserInfoWithUserName:(NSString *) userName;

@end

extern NSString *const kNSNotificationNameForLikeOrCommentView;

typedef void (^ReturnClickLabelBlock)(id indexPath);
typedef void (^ReturnTableViewCellBlock)(BOOL type,NSIndexPath *indexPath);
typedef void (^ReturnSelectedCellBlock)();

@interface FriendStatusCell : UITableViewCell

+ (CGFloat)calocCellHeightWithFriendStatus:(FriendStatusBean *) friendStatusBean;

- (void)dismissMenuSilderView;
- (void)setFriendStatus:(FriendStatusBean *)friendStatusBean;

@property (weak,nonatomic) id<FriendStatusCellDelegate> delegate;
@property (copy,nonatomic) ReturnClickLabelBlock returnClickLabelBlock;
@property (copy,nonatomic) ReturnTableViewCellBlock returnTableViewCellBlock;
@property (copy,nonatomic) ReturnSelectedCellBlock returnSelectedCellBlock;

@property (strong,nonatomic) NSIndexPath *indexPath;

@end
