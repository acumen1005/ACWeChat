//
//  RoomViewController.m
//  ChatDemo
//
//  Created by acumen on 16/4/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "RoomViewController.h"
#import "AddRoomViewController.h"
#import "RoomChatViewController.h"


#define indent 10.0

@interface RoomViewController ()<UITableViewDataSource,UITableViewDelegate,XMPPStreamDelegate,XMPPRoomStorage,XMPPRosterDelegate,XMPPRoomDelegate,NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *chatArray;
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) UIButton *publicButton;
@property (strong,nonatomic) UITextField *textField;

/** 结果调度器 */
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:NO];
    
    [self initData];
    [self initView];
    
    // 查询数据
    [self.fetchedResultsController performFetch:NULL];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40.0, 40.0)];
    [addButton setBackgroundImage:[UIImage imageNamed:@"chat_bottom_up_press"] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(onClickToAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
//    [[XMPPTool sharedXMPPTool] getExistRoom];
}

#pragma mark - lazy load

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return  _fetchedResultsController;
    }
    // 指定查询的实体
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"XMPPRoomOccupantCoreDataStorageObject"];
    
    // 在线状态排序
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    // 显示的名称排序
//    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"roomJID" ascending:YES];
    
    // 添加排序
//    request.sortDescriptors = @[sort1,sort2];
    request.sortDescriptors = @[sort1];
    // 添加谓词过滤器
//    request.predicate = [NSPredicate predicateWithFormat:@"!(subscription CONTAINS 'none')"];
    
    // 添加上下文
    NSManagedObjectContext *ctx = [XMPPTool sharedXMPPTool].xmppRoomCoreDataStorage.mainThreadManagedObjectContext;
    
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

- (void) initData{
    _chatArray = [[NSMutableArray alloc] init];
}

- (void) initView{

    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - tableViewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"%d",self.fetchedResultsController.fetchedObjects.count);
    
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"ChatCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XMPPRoomOccupantCoreDataStorageObject *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"%@ -- %@",room.jid,room.roomJID);
    
    cell.textLabel.text = room.roomJID.user;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    RoomChatViewController *roomChatVC = [[RoomChatViewController alloc] init];
    
    // 也可以直接用点语法
    NSIndexPath *indexpath = [self.tableView indexPathForSelectedRow];
    
    XMPPRoomOccupantCoreDataStorageObject *room = [self.fetchedResultsController objectAtIndexPath:indexpath];
    
    roomChatVC.jid = room.roomJID;
    [roomChatVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:roomChatVC animated:YES];
    
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    NSLog(@"上下文改变");
    [self.tableView reloadData];
}

#pragma mark - button action


- (void) onClickToAdd{
    
    AddRoomViewController *addRoomVC = [[AddRoomViewController alloc] init];
    
    [addRoomVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:addRoomVC animated:YES];
    
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
