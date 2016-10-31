//
//  CommonViewController.m
//  ChatDemo
//
//  Created by acumen on 16/10/31.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "CommonViewController.h"
#import "LL_HeaderView.h"

@interface CommonViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter

- (LL_HeaderView *) ll_HeaderView {
    if(!_ll_HeaderView){
        _ll_HeaderView = [[LL_HeaderView alloc] initWithFrame:CGRectMake(0, 0, 0, kScreenWidth * 0.9)];
    }
    return _ll_HeaderView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
