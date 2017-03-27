//
//  CommentBean.h
//  ChatDemo
//
//  Created by acumen on 16/8/4.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentBean : NSObject

@property (strong,nonatomic) NSString *fromUserName;
@property (strong,nonatomic) NSString *toUserName;
@property (strong,nonatomic) NSString *commentContent;

- (instancetype)initWithFromUserName:(NSString *)fromUserName
                          toUserName:(NSString *)toUserName
                      commentContent:(NSString *)commentContent;

@end
