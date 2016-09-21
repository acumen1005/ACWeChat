//
//  BaseViewModel.h
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewModel : NSObject

@property (copy, nonatomic) ReturnValueBlock returnBlock;
@property (copy, nonatomic) ErrorCodeBlock errorBlock;
@property (copy, nonatomic) FailureBlock failureBlock;

-(void) setBlockWithReturnBlock: (ReturnValueBlock) returnBlock
                 WithErrorBlock: (ErrorCodeBlock) errorBlock
               WithFailureBlock: (FailureBlock) failureBlock;

//返回成功
-(void)fetchSuccessResult:(NSDictionary *)message;

-(void)fetchErrorResult:(NSDictionary *)message;

-(void)fetchFailureResult;

@end
