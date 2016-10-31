//
//  UserManager.h
//  ChatDemo
//
//  Created by acumen on 16/10/31.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserBean.h"

@interface UserManager : NSObject

@property (strong, nonatomic) UserBean *userBean;

+ (instancetype) shareUserManager;

@end
