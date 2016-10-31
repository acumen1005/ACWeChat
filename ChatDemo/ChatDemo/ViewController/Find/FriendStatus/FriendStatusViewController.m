//
//  FriendStatusTableViewController.m
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendStatusViewController.h"
#import "FriendStatusRefreshHeaderView.h"
#import "KeyboardManager.h"
#import "FriendStatusCell.h"
#import "ModelHelper.h"
#import "UserBean.h"
#import "MenuSliderView.h"
#import "CommentBean.h"
#import "AccessoryView.h"
#import "AppDelegate.h"

#import "UserInfoViewController.h"
//#import "LL_HeaderView.h"

#define LOADING_Y  110

@interface FriendStatusViewController ()<UITableViewDataSource,UITableViewDelegate,FriendStatusCellDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) AccessoryView *accessoryView;

@property (strong,nonatomic) UIWindow *singleWindow;

@property (strong,nonatomic) NSArray *friendStatuses;
@property (strong,nonatomic) NSIndexPath *focuseIndexPath;

@property (strong,nonatomic) FriendStatusRefreshHeaderView *headerRefreshView;

@property (strong,nonatomic) NSMutableDictionary *cacheHeigtsDict;

@end

@implementation FriendStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"朋友圈"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.tableView];
    
    [self initData];
    [self initHeaderView];
    
    [self initAccessoryView];
    [self configNotification];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    // 模拟获取数据
    self.friendStatuses = [ModelHelper getFriendStatusWithCount:6];
    
    {
        int count = 0;
        [self.cacheHeigtsDict removeAllObjects];
        for (FriendStatusBean *fsb in self.friendStatuses) {
            
            [self ll_updateCellHeightWithIndexPath:[NSIndexPath indexPathForRow:count inSection:0] isWeak:NO friendStatus:fsb];
            count++;
        }
    }
    
    if (!_headerRefreshView.superview) {
        
        _headerRefreshView = [FriendStatusRefreshHeaderView refreshHeaderWithCenter:CGPointMake(40, 45)];
        _headerRefreshView.scrollView = self.tableView;
        __weak typeof(_headerRefreshView) weakHeader = _headerRefreshView;
        __weak typeof(self) weakSelf = self;
        [_headerRefreshView setRefreshingBlock:^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                weakSelf.friendStatuses = [ModelHelper getFriendStatusWithCount:6];
                
                // 修改cell内容时要重新计算高度
                {
                    int count = 0;
                    [weakSelf.cacheHeigtsDict removeAllObjects];
                    for (FriendStatusBean *fsb in weakSelf.friendStatuses) {
                        
                        [weakSelf ll_updateCellHeightWithIndexPath:[NSIndexPath indexPathForRow:count inSection:0] isWeak:YES friendStatus:fsb];
                        count++;
                    }
                }
                
                [weakHeader endRefreshing];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            });
        }];
        [self.tableView.superview addSubview:_headerRefreshView];
    } else {
        [self.tableView.superview bringSubviewToFront:_headerRefreshView];
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void) initData {
    
    [UserManager shareUserManager].userBean = [ModelHelper getUserBean:@"acumen"];
    
    self.cacheHeigtsDict = [[NSMutableDictionary alloc] init];
}

- (void) configNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) initAccessoryView {
    
    [self.singleWindow addSubview:self.accessoryView];
    
    __weak typeof(self) weakSelf = self;
    self.accessoryView.returnTextViewContentBlock = ^(NSString *content, NSIndexPath *indexPath){
    
        if(indexPath == nil){
            return ;
        }

        FriendStatusBean *friendStatusBean = [weakSelf.friendStatuses objectAtIndex:indexPath.row];
        
        CommentBean *commentBean = [[CommentBean alloc] init];
        commentBean.fromUserName = @"acumen";
        commentBean.toUserName = friendStatusBean.userName;
        commentBean.commentContent = content;
        [friendStatusBean.comments addObject:commentBean];
        
        // 重新计算
        [weakSelf ll_updateCellHeightWithIndexPath:indexPath isWeak:YES friendStatus:friendStatusBean];
        
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        weakSelf.accessoryView.commentTextView.text = @"";
        [weakSelf.accessoryView.commentTextView resignFirstResponder];
    };
}

- (void) initHeaderView {
    
    UserBean *userBean = [UserManager shareUserManager].userBean;
    
    [self.ll_HeaderView setUserName:userBean.userName avatar:userBean.avatar backgroudImage:userBean.bottleBackgroud];
    
    self.tableView.tableHeaderView = self.ll_HeaderView;
}

#pragma mark - getter

- (UIWindow *) singleWindow {
    if(!_singleWindow){
        _singleWindow = [[UIApplication sharedApplication] keyWindow];
    }
    return _singleWindow;
}

- (AccessoryView *) accessoryView {
    if(!_accessoryView){
        _accessoryView = [[AccessoryView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, BUTTON_HEIGHT)];
        [_accessoryView setBackgroundColor:COLOR_RGBA(240, 240, 240, 1.0)];
    }
    return _accessoryView;
}

- (UITableView *) tableView {
    
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -BUTTON_HEIGHT * 2, kScreenWidth, kScreenHeight + BUTTON_HEIGHT * 2)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setBackgroundColor:[UIColor grayColor]];
        [_tableView registerClass:[FriendStatusCell class] forCellReuseIdentifier:@"FriendStatusCell"];
    }
    return _tableView;
}

#pragma mark - UIKeyboardDidShowNotification

- (void) keyboardWillChangeFrame:(NSNotification *) notification {

    // 获取键盘基本信息（动画时长与键盘高度）
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.accessoryView setBottom:kScreenHeight - keyboardHeight];
    
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    
    // 获得键盘动画时长
    NSDictionary *userInfo = [notification userInfo];
    CGFloat keyboardDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [self.accessoryView setTop:kScreenHeight];
    
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - FriendStatusCellDelegate

- (void) onClickToComment:(NSIndexPath *) indexPath{
    
    self.accessoryView.indexPath = indexPath;
    [self.accessoryView.commentTextView becomeFirstResponder];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) onClickToGivenLike:(NSIndexPath *) indexPath IsClicked:(BOOL)click{
    
    FriendStatusBean *friendStatusBean = [self.friendStatuses objectAtIndex:indexPath.row];
    
    if(click) {
        
        UserBean *userBean = [[UserBean alloc] init];
        userBean.userName = @"acumen";
        userBean.userId = [NSNumber numberWithInt:1];
        [friendStatusBean.likes addObject:userBean];
    }
    else {
        for (UserBean *tmp in friendStatusBean.likes) {
            if([tmp.userId isEqualToNumber:@1]){
                [friendStatusBean.likes removeObject:tmp];
            }
        }
    }
}

- (void) onClickToPushUserInfo:(NSIndexPath *)indexPath {

    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    
    FriendStatusBean *friendStatusBean = [self.friendStatuses objectAtIndex:indexPath.row];
    
    userInfoVC.userBean = [ModelHelper getUserBean:friendStatusBean.userName];
    
    [userInfoVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:userInfoVC animated:YES];
}


- (void) onClickToPushUserInfoWithUserName:(NSString *) userName {

    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
    
    userInfoVC.userBean = [ModelHelper getUserBean:userName];
    
    [userInfoVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:userInfoVC animated:YES];
    
}

#pragma mark - touch

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //    [super touchesBegan:touches withEvent:event];
    
}

#pragma mark - 更新 cell 高度

- (void) ll_updateCellHeightWithIndexPath:(NSIndexPath *) indexPath isWeak:(BOOL) weak friendStatus:(FriendStatusBean *) friendStatus {
    
    CGFloat height = [FriendStatusCell calocCellHeightWithFriendStatus:friendStatus];
    if(!weak){
        [self.cacheHeigtsDict setObject:@(height) forKey:indexPath];
    }
    else {
        __weak typeof(self) wSelf = self;
        [wSelf.cacheHeigtsDict setObject:@(height) forKey:indexPath];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.friendStatuses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //forIndexPath:indexPath
    FriendStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendStatusCell"];
    
    [cell setFriendStatus:self.friendStatuses[indexPath.row]];
    cell.indexPath = indexPath;
    cell.delegate = self;
    __weak typeof(self) weakSelf = self;
    if (!cell.returnClickLabelBlock) {
        cell.returnClickLabelBlock = ^(id indexPath){
            NSIndexPath *tmp = indexPath;
            
            FriendStatusBean *friendStatusBean = weakSelf.friendStatuses[tmp.row];
            friendStatusBean.isOpen = !friendStatusBean.isOpen;
            
            // 重新计算
            CGFloat height = [FriendStatusCell calocCellHeightWithFriendStatus:friendStatusBean];
            [self.cacheHeigtsDict setObject:@(height) forKey:indexPath];
            
            [weakSelf.tableView reloadData];
        };
    }
    
    if(!cell.returnTableViewCellBlock) {
        cell.returnTableViewCellBlock = ^(BOOL type,NSIndexPath *indexPath){
            
            FriendStatusBean *friendStatusBean = weakSelf.friendStatuses[indexPath.row];
            //初始化
            BOOL needUpdate = false;
            for (FriendStatusBean *tmp in weakSelf.friendStatuses) {
                if(type && tmp == friendStatusBean) {
                    needUpdate = true;
                    continue;
                }
                tmp.isCommentStatus = NO;
            }
            if(type){
                friendStatusBean.isCommentStatus = !friendStatusBean.isCommentStatus;
            }
            
            CGFloat height = [FriendStatusCell calocCellHeightWithFriendStatus:friendStatusBean];
            [self.cacheHeigtsDict setObject:@(height) forKey:indexPath];
            
            [weakSelf.tableView reloadData];
        };
    }
    
    if(!cell.returnSelectedCellBlock){
        cell.returnSelectedCellBlock = ^(){
            [weakSelf.singleWindow endEditing:YES];
        };
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id value = [self.cacheHeigtsDict objectForKey:indexPath];
    
    if(!value){
        CGFloat height = [FriendStatusCell calocCellHeightWithFriendStatus:self.friendStatuses[indexPath.row]];
        [self.cacheHeigtsDict setObject:@(height) forKey:indexPath];
    }
    
    return [[self.cacheHeigtsDict objectForKey:indexPath] floatValue];
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
