//
//  RequestManager.m
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "RequestManager.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager;

@end

@implementation AFHTTPSessionManager (Shared)

+ (instancetype)sharedManager {
    static AFHTTPSessionManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [AFHTTPSessionManager manager];
        //设置接受字段
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
    });
    return _instance;
}
@end

@implementation RequestManager



+ (void)GET:(NSString *)url
 parameters:(id)parameters
    success:(void(^)(id responseObject))success
    failure:(void(^)(NSError *error))failure{
    
    //请求头设置
//    [[AFHTTPSessionManager sharedManager].requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
    [[AFHTTPSessionManager sharedManager] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //
        if(success){
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            failure(error);
        }
    }];
}

+ (void)POST:(NSString *)url
  parameters:(id)parameters
     success:(void(^)(id responseObject))success
     failure:(void(^)(NSError *error))failure{
    
    //请求头设置
    //    [[AFHTTPSessionManager sharedManager].requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
    [[AFHTTPSessionManager sharedManager] POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        if(success){
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(failure){
            failure(error);
        }
    }];
}

@end
