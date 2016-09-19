//
//  AddRoomViewController.m
//  ChatDemo
//
//  Created by acumen on 16/5/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "AddRoomViewController.h"

@interface AddRoomViewController ()

@property (strong,nonatomic) UITextField *nameText;

@end

@implementation AddRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0f];
    
    [self initView];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40.0, 40.0)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(onClickToAdd) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

#pragma mark - init

- (void) initView{
    
    _nameText = [[UITextField alloc] initWithFrame:CGRectMake(0, 80.0, kScreenWidth, 40.0)];
    _nameText.backgroundColor = [UIColor whiteColor];
    _nameText.placeholder = @"创建群组名称";
    
    [self.view addSubview:_nameText];
}


#pragma mark - button action

- (void) onClickToAdd{

    // 你写了域名那更好，你没写系统就自动帮你补上
    NSRange range = [_nameText.text rangeOfString:@"@conference."];
    // 如果没找到 NSNotFound，不要写0
    if (range.location == NSNotFound) {
        //@conference.acumendemacbook-pro.local
        _nameText.text = [_nameText.text stringByAppendingFormat:@"@conference.%@", [XMPPTool sharedXMPPTool].xmppStream.myJID.domain];
    }    
    
    XMPPJID *roomJID = [XMPPJID jidWithString:_nameText.text];
    [XMPPTool sharedXMPPTool].xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:[XMPPTool sharedXMPPTool].xmppRoomCoreDataStorage jid:roomJID];
    
    [[XMPPTool sharedXMPPTool].xmppRoom activate:[XMPPTool sharedXMPPTool].xmppStream];
    
    [[XMPPTool sharedXMPPTool].xmppRoom joinRoomUsingNickname:[XMPPTool sharedXMPPTool].xmppStream.myJID.user history:nil];
        [[XMPPTool sharedXMPPTool].xmppRoom addDelegate:[XMPPTool sharedXMPPTool] delegateQueue:dispatch_get_main_queue()];
    
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
