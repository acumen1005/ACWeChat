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
#import "FriendsCell.h"

@interface FriendsViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
/** 结果调度器 */
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"好友列表";
    
    [self initData];
    [self initView];
    // 查询数据
    [self.fetchedResultsController performFetch:NULL];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40.0, 40.0)];
    [backButton setTitle:@"注销" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onClickToBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40.0, 40.0)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(onClickToAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    [[XMPPTool sharedXMPPTool] getAllRegisteredUsers];
}

#pragma mark - lazy load

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
//    NSManagedObjectContext *ctx = [XMPPTool sharedXMPPTool].;
    
    // 实例化结果控制器
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    
    // 设置他的代理
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (UITableView *) tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - init

- (void) initData{
    _dataArray = [[NSMutableArray alloc] init];
}

- (void) initView{
    [self.view addSubview:self.tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    NSLog(@"%d",self.fetchedResultsController.fetchedObjects.count);
    
    return self.fetchedResultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    XMPPUserCoreDataStorageObject *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
//    NSLog(@"%@ %zd %@ %@ ", user.jidStr,user.section, user.sectionName, user.sectionNum);
    
    // subscription
    // 如果是none表示对方还没有确认
    // to   我关注对方
    // from 对方关注我
    // both 互粉
    
    NSString *str = [user.jidStr stringByAppendingFormat:@" | %@",user.subscription];
    
    NSLog(@"%@ - 状态： %@",user.jid.user ,[self userStatusWithSection:user.section]);
    
    cell.textLabel.text = [[self userStatusWithSection:user.section] stringByAppendingFormat:@"   %@",str];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    
    return cell;
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
    
    // 也可以直接用点语法
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    
    XMPPUserCoreDataStorageObject *user = [self.fetchedResultsController objectAtIndexPath:indexpath];
    
    singleVC.jid = user.jid;
    NSLog(@"%@...",[NSString stringWithFormat:@"%@@%@",@"user9",LOCAL_HOST]);
    singleVC.jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",@"user9",LOCAL_HOST]];
    
    [singleVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:singleVC animated:YES];
    
}

#pragma mark - logout 

- (void) onClickToAdd{

//    AddFriendsViewController *addFriendsVC = [[AddFriendsViewController alloc] init];
//    
//    [self.navigationController pushViewController:addFriendsVC animated:YES];
    
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
