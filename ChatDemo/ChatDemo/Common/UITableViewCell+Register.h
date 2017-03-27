//
//  UITableViewCell+Register.h
//  ChatDemo
//
//  Created by acumen on 17/3/27.
//  Copyright © 2017年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Register)

+ (void)registerNibForTableView:(UITableView *)tableView;
+ (void)registerClassForTableView:(UITableView *)tableView;

@end
