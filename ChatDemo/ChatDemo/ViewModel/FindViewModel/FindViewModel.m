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


- (void) getFindStatus {
    
    NSString *userId = @"T1348647853363";
    
    NSString *url = [NSString stringWithFormat:@"https://c.m.163.com/nc/article/headline/%@/10-20.html",userId];
    
    BaseRequest *request = [BaseRequest initBaseRequestWithUrl:url Type:BaseRequestPost];
    
    [request sendRequestWithReturnBlock:^(id returnValue) {
        
        NSLog(@"---- %@",returnValue);
        
        NSDictionary *dict = returnValue;
        
        NSDictionary *leaves = [dict objectForKey:userId];
        
        
        [self fetchSuccessResult:returnValue];
        
    } WithFailureBlock:^{
        
    }];
}

@end
