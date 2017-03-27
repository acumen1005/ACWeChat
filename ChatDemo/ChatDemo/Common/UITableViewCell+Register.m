//
//  UITableViewCell+Register.m
//  ChatDemo
//
//  Created by acumen on 17/3/27.
//  Copyright © 2017年 acumen. All rights reserved.
//

#import "UITableViewCell+Register.h"

@implementation UITableViewCell (Register)

+ (NSString *)name {
    return NSStringFromClass([self class]);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:[self name] bundle:nil];
}

+ (void)registerClassForTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:[self name]];
}

+ (void)registerNibForTableView:(UITableView *)tableView {
    [tableView registerNib:[self nib] forCellReuseIdentifier:[self name]];
}


@end
