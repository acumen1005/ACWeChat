//
//  CommentBean.m
//  ChatDemo
//
//  Created by acumen on 16/8/4.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "CommentBean.h"

@implementation CommentBean

- (instancetype)init {
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (instancetype)initWithFromUserName:(NSString *)fromUserName
                          toUserName:(NSString *)toUserName
                      commentContent:(NSString *)commentContent {
    self = [super init];
    if (self) {
        self.fromUserName = fromUserName;
        self.toUserName = toUserName;
        self.commentContent = commentContent;
    }
    return self;
}


@end
