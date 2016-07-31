//
//  FriendStatusCell.h
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendStatusBean.h"

typedef void (^ReturnClickLabelBlock)(id indexPath);

@interface FriendStatusCell : UITableViewCell

- (void) setFriendStatus:(FriendStatusBean *) friendStatusBean;
+ (CGFloat) calocCellHeightWithFriendStatus:(FriendStatusBean *) friendStatusBean;

@property (copy,nonatomic) ReturnClickLabelBlock returnClickLabelBlock;
@property (strong,nonatomic) NSIndexPath *indexPath;

@end
