//
//  UserInfoViewController.m
//  ChatDemo
//
//  Created by acumen on 16/10/31.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:self.userBean.userName];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tableView];
    
    [self configHeaderView];
    
    [self.ll_HeaderView setUserName:self.userBean.userName avatar:self.userBean.avatar backgroudImage:self.userBean.bottleBackgroud];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - config 

- (void) configSubViews {
    
}

- (void) configHeaderView {
    
    self.tableView.tableHeaderView = self.ll_HeaderView;
}

#pragma mark - getter 

- (UITableView *) tableView {
    
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -BUTTON_HEIGHT * 2, kScreenWidth, kScreenHeight + BUTTON_HEIGHT * 2)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor grayColor]];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}


#pragma mark - dataSouce

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

#pragma mark - tableViewDelegate 


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return BUTTON_HEIGHT;
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
