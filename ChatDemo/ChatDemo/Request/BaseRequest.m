//
//  BaseRequest.m
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "BaseRequest.h"
#import <AFNetworking.h>
#import "RequestManager.h"

@implementation BaseRequest

#pragma mark - 初始化

+ (instancetype) initBaseRequest{
    return [[BaseRequest alloc] init];
}

+ (instancetype) initBaseRequestWithUrl:(NSString *)url {
    return [self initBaseRequestWithUrl:url Type:BaseRequestPost];
}

+ (instancetype) initBaseRequestWithUrl:(NSString *)url Type:(BaseRequestType)type {
    
    BaseRequest *baseRequest = [self initBaseRequest];
    baseRequest.url = url;
    baseRequest.baseRequestType = type;
    
    return baseRequest;
}


- (void)sendRequestWithReturnBlock: (ReturnValueBlock)returnValueBlock
                  WithFailureBlock: (FailureBlock) failureBlock {
    
    NSString *url = self.url;
    NSDictionary *parameters = self.paramDict;
    
    switch (self.baseRequestType) {
        //post请求
        case BaseRequestPost:
        {
            [RequestManager POST:url parameters:parameters success:^(id responseObject) {
                
                if(returnValueBlock){
                    returnValueBlock(responseObject);
                }
                
            } failure:^(NSError *error) {
                
                if(failureBlock){
                    failureBlock(error);
                }
            }];
            
            break;
        }
        //GET请求
        case BaseRequestGet:
        {
            [RequestManager GET:url parameters:parameters success:^(id responseObject) {
                
                if(returnValueBlock){
                    returnValueBlock(responseObject);
                }
                
            } failure:^(NSError *error) {
                
                if(failureBlock){
                    failureBlock(error);
                }
            }];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark - 私有方法



@end
