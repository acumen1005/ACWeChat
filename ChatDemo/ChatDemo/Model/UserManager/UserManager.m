//
//  UserManager.m
//  ChatDemo
//
//  Created by acumen on 16/10/31.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager


- (instancetype)init {
    if(self = [super init]) {
    }
    return self;
}

+ (instancetype) shareUserManager {
    static UserManager *userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [[UserManager alloc] init];
    });
    return userManager;
}

@end
