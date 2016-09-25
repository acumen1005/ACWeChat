//
//  FriendsTableViewController.m
//  ChatDemo
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendsViewController.h"
#import "SingleViewController.h"
#import "AddFriendsViewController.h"
#import "ResultsViewController.h"
#import "FriendsCell.h"

@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) ResultsViewController *resultsController;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
/** 结果调度器 */
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@property (strong,nonatomic) UISearchController *searchController;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"好友列表";
    
    [self initData];
    [self initView];
}

#pragma mark - lazy load

- (ResultsViewController *) resultsController {
    if(!_resultsController) {
        _resultsController = [[ResultsViewController alloc] init];
    }
    return  _resultsController;
}


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return  _fetchedResultsController;
    }
    // 指定查询的实体
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 在线状态排序
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionNum" ascending:YES];
    // 显示的名称排序
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    
    // 添加排序
    request.sortDescriptors = @[sort1,sort2];
    
    // 添加谓词过滤器
    request.predicate = [NSPredicate predicateWithFormat:@"!(subscription CONTAINS 'none')"];
    
    // 添加上下文
    NSManagedObjectContext *ctx = [XMPPTool sharedXMPPTool].xmppRosterCoreDataStorage.mainThreadManagedObjectContext;
    
    // 实例化结果控制器
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    
    // 设置他的代理
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (UITableView *) tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FriendsCell class] forCellReuseIdentifier:@"FriendsCell"];
    }
    return _tableView;
}

#pragma mark - init

- (void) initData{
    
//    _dataArray = [[NSMutableArray alloc] init];
}

- (void) initView{
    
    if(self.loginType == FriendsViewControllerNeed2Login) {
        
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (XMPPUserCoreDataStorageObject *user in self.fetchedResultsController.fetchedObjects) {
            
            [mArray addObject:user.jid.user];
        }
        self.resultsController.dataSource = mArray;
        // 查询数据
        [self.fetchedResultsController performFetch:NULL];
        [[XMPPTool sharedXMPPTool] getAllRegisteredUsers];
    }
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
    
    self.searchController.searchResultsUpdater = self.resultsController;
    [self.searchController.searchBar sizeToFit];
    
    [self.view addSubview: self.tableView];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40.0, 40.0)];
    [backButton setTitle:@"注销" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickToBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40.0, 40.0)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(onClickToAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.loginType == FriendsViewControllerNeed2Login) {
        return self.fetchedResultsController.fetchedObjects.count;
    }
    else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsCell"];
    
    if(!cell){
        cell = [[FriendsCell alloc] init];
    }
    
    XMPPUserCoreDataStorageObject *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // subscription
    // 如果是none表示对方还没有确认
    // to   我关注对方
    // from 对方关注我
    // both 互粉
    
    [cell setNameLabelWithString:user.jid.user AvatarImageView:@"3"];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return BUTTON_HEIGHT + 10.0;
}

- (NSString *)userStatusWithSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"在线";
            break;
        case 1:
            return @"离开";
            break;
        case 2:
            return @"离线";
            break;
        default:
            return @"未知";
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{    
    NSLog(@"上下文改变");
    [self.tableView reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SingleViewController *singleVC = [[SingleViewController alloc] init];
    
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    
    XMPPUserCoreDataStorageObject *user = [self.fetchedResultsController objectAtIndexPath:indexpath];
    
    singleVC.jid = user.jid;
    
    [singleVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:singleVC animated:YES];
    
}

#pragma mark - logout 

- (void) onClickToAdd{

    AddFriendsViewController *addFriendsVC = [[AddFriendsViewController alloc] init];
    
    [self.navigationController pushViewController:addFriendsVC animated:YES];
    
}

- (void) onClickToBack{
    
    [[XMPPTool sharedXMPPTool] logout];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
