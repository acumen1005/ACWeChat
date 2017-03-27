//
//  RequestManager.h
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestManager : NSObject


/**
 *  GET请求
 *
 *  @param url        URL
 *  @param parameters 参数
 *  @param success    请求成功block
 *  @param failure    请求失败block
 */

+ (void)GET:(NSString *)url parameters:(id)parameters
    success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

/**
 *  POST请求
 *
 *  @param url        URL
 *  @param parameters 参数
 *  @param success    请求成功block
 *  @param failure    请求失败block
 */

+ (void)POST:(NSString *)url parameters:(id)parameters
     success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;


@end
