//
//  FriendsCell.h
//  ChatDemo
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsCell : UITableViewCell

@property (strong,nonatomic) UILabel *nameLabel;

- (void) setNameLabel:(NSString *)name;

@end
