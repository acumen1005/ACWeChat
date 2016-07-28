//
//  FriendStatusTableViewController.m
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendStatusViewController.h"

#define LOADING_Y  110

@interface FriendStatusViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UIView *headerView;
@property (strong,nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) UIView *bgAvatarView;
@property (strong,nonatomic) UILabel *nameLabel;

@property (strong,nonatomic) UIImageView *loadingView;

@end

@implementation FriendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"朋友圈"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tableView];
    [self initHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void) initHeaderView {

    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    _avatarImageView = [[UIImageView alloc] init];
    _bgAvatarView = [[UIView alloc] init];
    _nameLabel = [[UILabel alloc] init];
    _loadingView = [[UIImageView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];

    self.tableView.tableHeaderView = _headerView;
    [_headerView addSubview:_avatarImageView];
    [_headerView addSubview:_bgAvatarView];
    [_headerView addSubview:_nameLabel];
    [_headerView addSubview:imageView];
    [_headerView sendSubviewToBack:imageView];
    [self.view addSubview:_loadingView];
    [_headerView bringSubviewToFront:_avatarImageView];
    
    [_headerView setBackgroundColor:[UIColor whiteColor]];

    [_bgAvatarView setBackgroundColor:[UIColor whiteColor]];
    [[_bgAvatarView layer] setBorderWidth:0.5];
    [[_bgAvatarView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [_avatarImageView setImage:[UIImage imageNamed:@"2"]];
    
    [_nameLabel setText:@"acumen"];
    [_nameLabel setTextColor:[UIColor whiteColor]];
    [_nameLabel setShadowColor:[UIColor grayColor]];
    [_nameLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    [_nameLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_nameLabel sizeToFit];
    
    [_loadingView setImage:[UIImage imageNamed:@"ff_IconShowAlbum"]];
    [_loadingView setBackgroundColor:[UIColor whiteColor]];
    [[_loadingView layer] setMasksToBounds:YES];
    [[_loadingView layer] setCornerRadius:15.0];
    
    [imageView setImage:[UIImage imageNamed:@"bottleBkg"]];
    
    CGFloat space = 3.0;
    CGFloat avatarSize = kScreenWidth/5.0;
    
    [imageView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.8)];
    [_bgAvatarView setFrame:CGRectMake(kScreenWidth - avatarSize * 0.3 - avatarSize, imageView.bottom - avatarSize * 0.7, avatarSize, avatarSize)];
    [_avatarImageView setFrame:CGRectMake(_bgAvatarView.x + space,_bgAvatarView.y + space, avatarSize - space * 2, avatarSize - space * 2)];
    
    [_nameLabel setRight:_bgAvatarView.x - 10.0];
    [_nameLabel setBottom:imageView.bottom - 10.0];
    
    [_loadingView setFrame:CGRectMake(20.0, BUTTON_HEIGHT * 2 - 40.0, 30.0, 30.0)];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BUTTON_HEIGHT;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSLog(@"%f -----------",scrollView.contentOffset.y);
    
    CGFloat y = scrollView.contentOffset.y;
    
    if(y <= -LOADING_Y){
        
    }
    else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [_loadingView setY:-(y + 30.0)];
            [self.view layoutIfNeeded];
        });
    }
    
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
