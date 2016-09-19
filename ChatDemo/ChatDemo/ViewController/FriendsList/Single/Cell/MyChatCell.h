//
//  MyChatCell.h
//  yb
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyChatCell : UITableViewCell


@property (strong,nonatomic) UIImageView *avatarView;
@property (strong,nonatomic) UILabel *contextLabel;
@property (strong,nonatomic) UIImageView *bgImage;

- (void) setNameLabel:(NSString *)name ContextLabel:(NSString *) context;

@end
