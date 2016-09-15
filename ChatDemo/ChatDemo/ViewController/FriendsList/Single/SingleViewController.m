//
//  SingleViewController.m
//  ChatDemo
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "SingleViewController.h"
#import "MyChatCell.h"
#import "OtherChatCell.h"
#import "XMPPMessage+Tools.h"

#define indent 10.0

@interface SingleViewController ()<UITableViewDataSource,UITableViewDelegate,XMPPStreamDelegate,XMPPRoomStorage,XMPPRosterDelegate,XMPPRoomDelegate,NSFetchedResultsControllerDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *chatArray;
@property (strong,nonatomic) UIView *bottomView;
@property (strong,nonatomic) UIButton *publicButton;
@property (strong,nonatomic) UITextField *textField;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property(nonatomic,strong) NSCache *cache;

@end

@implementation SingleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:NO];
    self.title = _jid.user;
    
    [self initData];
    [self initView];
    
    [self.fetchedResultsController performFetch:NULL];
    [self scrollToBottom];
}


- (NSFetchedResultsController *)fetchedResultsController {
    // 推荐写法，减少嵌套的层次
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    // 先确定需要用到哪个实体
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    // 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 每一个聊天界面，只关心聊天对象的消息
    request.predicate = [NSPredicate predicateWithFormat:@"bareJidStr = %@", self.jid.bare];
    
    // 从自己写的工具类里的属性中得到上下文
    NSManagedObjectContext *ctx = [XMPPTool sharedXMPPTool].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext;
    
    // 实例化，里面要填上上面的各种参数
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:ctx sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (UITableView *) tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0f];
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
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:0.5f];
    
    _textField= [[UITextField alloc] initWithFrame:CGRectMake(indent, indent - 2, kScreenWidth * 0.7, _bottomView.height - 2 * (indent - 2))];
    _textField.font = [UIFont systemFontOfSize:14.0];
    _textField.placeholder = @"我要回复";
    _textField.layer.masksToBounds = YES;
    _textField.layer.cornerRadius = 5.0f;
    _textField.layer.borderWidth = 1.0f;
    _textField.returnKeyType = UIReturnKeySend;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 115.0/255, 115.0/255, 115.0/255, 0.3 });
    [_textField.layer setBorderColor:colorref];//边框颜色
    _textField.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1.0)];
    line.backgroundColor = [UIColor colorWithRed:165.0/255 green:165.0/255 blue:165.0/255 alpha:0.3f];
    
    _publicButton = [[UIButton alloc] initWithFrame:CGRectMake(self.textField.right + indent, self.textField.y,kScreenWidth - self.textField.right - 2 * indent, self.textField.height)];
    [_publicButton setTitle:@"发送" forState:UIControlStateNormal];
    [_publicButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _publicButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_publicButton setBackgroundColor:[UIColor orangeColor]];
    _publicButton.layer.masksToBounds = YES;
    _publicButton.layer.cornerRadius = 5.0;
    [_publicButton addTarget:self action:@selector(actionToSend) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:_publicButton];
    [_bottomView addSubview:self.textField];
    [_bottomView addSubview:line];
    [self.view addSubview:_bottomView];
    
}

#pragma mark -结果调度器的代理方法
// 内容变化(接收到其他好友的/我发送的消息)的时候，会触发
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
    
    [self scrollToBottom];
}


#pragma mark - tableViewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.fetchedResultsController.fetchedObjects.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMPPMessageArchiving_Message_CoreDataObject *message = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // 判断是发出消息还是接收消息
    NSString *ID = ([message.outgoing intValue] != 1) ? @"MyChatCell" : @"OtherChatCell" ;
    if([ID isEqualToString:@"MyChatCell"]){
    
        MyChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
        if(!cell){
            cell = [[MyChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        // 如果存进去了，就把字符串转化成简洁的节点后保存
        if ([message.message saveAttachmentJID:self.jid.bare timestamp:message.timestamp]) {
        message.messageStr = [message.message compactXMLString];
        
            [[XMPPTool sharedXMPPTool].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
        }
    
        NSString *path = [message.message pathForAttachment:self.jid.bare timestamp:message.timestamp];
    
        if ([message.body isEqualToString:@"image"]) {
        
        }else if ([message.body hasPrefix:@"audio"]){
    
        }else{
            [cell setNameLabel:self.jid.user ContextLabel:message.body];
        }
        
        return cell;
    }
    else {
    
        OtherChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        if(!cell){
            cell = [[OtherChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        // 如果存进去了，就把字符串转化成简洁的节点后保存
        if ([message.message saveAttachmentJID:self.jid.bare timestamp:message.timestamp]) {
            message.messageStr = [message.message compactXMLString];
            
            [[XMPPTool sharedXMPPTool].xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext save:NULL];
        }
        
        NSString *path = [message.message pathForAttachment:self.jid.bare timestamp:message.timestamp];
        
        if ([message.body isEqualToString:@"image"]) {
            
        }else if ([message.body hasPrefix:@"audio"]){
            
        }else{
            [cell setNameLabel:self.jid.user ContextLabel:message.body];
        }
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0;
}

#pragma mark - send Message

/** 发送信息 */
- (void)sendMessage:(NSString *)message
{
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.jid];
    
    [msg addBody:message];
    
    [[XMPPTool sharedXMPPTool].xmppStream sendElement:msg];
}

#pragma mark - custom action

// 滚动到表格的末尾，显示最新的聊天内容
- (void)scrollToBottom {
    
    // 1. indexPath，应该是最末一行的indexPath
    NSInteger count = self.fetchedResultsController.fetchedObjects.count;
    
    // 数组里面没东西还滚，不是找崩么
    if (count > 3) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(count - 1) inSection:0];
        
        // 2. 将要滚动到的位置
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - button action

- (void) actionToSend{
    
    [self sendMessage:_textField.text];
    
    [self.view endEditing:YES];
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
