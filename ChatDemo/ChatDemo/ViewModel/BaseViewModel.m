//
//  BaseViewModel.m
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock
{
    self.returnBlock = returnBlock;
    self.errorBlock = errorBlock;
    self.failureBlock = failureBlock;
}

//与接口衔接好
-(void)fetchSuccessResult:(NSDictionary *)message{
//    if ([message[HTTP_RESULT] isEqualToString:HTTP_SUCCESS]) {
        self.returnBlock(message[HTTP_MSG]);
//    }else{
//        self.errorBlock(message[HTTP_MSG]);
//    }
}

-(void)fetchErrorResult:(NSDictionary *)message{
    if ([message[HTTP_RESULT] isEqualToString:HTTP_FAILUER]) {
        self.returnBlock(message);
    }else{
        self.errorBlock(@"系统错误");
    }
}

-(void)fetchFailureResult{
    self.failureBlock(@"网络错误");
}

@end
