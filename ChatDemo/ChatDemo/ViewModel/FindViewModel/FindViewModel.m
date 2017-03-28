//
//  FindViewModel.m
//  ChatDemo
//
//  Created by acumen on 16/9/21.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FindViewModel.h"
#import "BaseRequest.h"

@implementation FindViewModel


- (void)getFindStatus{
    
//    NSString *userId = @"280";
    NSMutableDictionary *mDict = [[NSMutableDictionary alloc] init];
//    [mDict setObject:userId forKey:@"id"];
    //
    //
    NSString *url = [NSString stringWithFormat:@""];
    
    BaseRequest *request = [BaseRequest initBaseRequestWithUrl:url Type:BaseRequestPost];
    
    [request sendRequestWithReturnBlock:^(id returnValue) {
        
        NSLog(@"---- %@",returnValue);
        
        [self fetchSuccessResult:returnValue];
        
    } WithFailureBlock:^{
        
    }];
}

@end
