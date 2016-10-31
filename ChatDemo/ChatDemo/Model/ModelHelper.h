//
//  ModelHelper.h
//  ChatDemo
//
//  Created by acumen on 16/7/30.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserBean.h"

@interface ModelHelper : NSObject

+ (NSArray *) getFriendStatusWithCount:(NSInteger) count;
+ (UserBean *) getUserBean:(NSString *) userName;


@end
