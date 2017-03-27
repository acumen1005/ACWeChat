//
//  BaseRequest.h
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BaseRequestType){
    BaseRequestPost     = 0,
    BaseRequestGet      = 1,
    BaseRequestPut      = 2,
    BaseRequestDelete   = 3,
};

@interface BaseRequest : NSObject

@property (strong,nonatomic) NSString *url;

@property (assign,nonatomic) BaseRequestType baseRequestType;

@property (strong,nonatomic) NSDictionary *paramDict;

@property (copy,nonatomic) ReturnValueBlock returnValueBlock;
@property (copy,nonatomic) FailureBlock failureBlock;

//初始化
+ (instancetype) initBaseRequest;
+ (instancetype) initBaseRequestWithUrl:(NSString *) url;
+ (instancetype) initBaseRequestWithUrl:(NSString *) url Type:(BaseRequestType) type;

//返回block
- (void)sendRequestWithReturnBlock: (ReturnValueBlock)returnValueBlock
                  WithFailureBlock: (FailureBlock) failureBlock;

@end
