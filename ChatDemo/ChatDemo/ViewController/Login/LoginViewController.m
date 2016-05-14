//
//  LoginViewController.m
//  ChatDemo
//
//  Created by acumen on 16/4/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "XMPPMessage+Tools.h"
#import "FriendsViewController.h"
#import "RoomViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<XMPPStreamDelegate,XMPPRoomStorage,XMPPRosterDelegate,XMPPRoomDelegate>

@property (strong,nonatomic) UITextField *userText;
@property (strong,nonatomic) UITextField *pwdText;
@property (strong,nonatomic) UIButton *registerButton;
@property (strong,nonatomic) RoomViewController *roomVC;
@property (strong,nonatomic) RegisterViewController *registerVC;

@property (strong, nonatomic) NSMutableArray *rosterArray;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self initData];
    [self initView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToLogin:) name:ResultNotification object:nil];
}


- (RoomViewController *) roomVC{
    if(!_roomVC){
        _roomVC = [[RoomViewController alloc] init];
    }
    return _roomVC;
}

- (void) initData{
    
    _rosterArray = [[NSMutableArray alloc] init];
}

- (void) initView{

    _userText = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth * 0.15, kScreenHeight * 0.3, kScreenWidth * 0.7, 40.0)];
    _userText.placeholder = @"用户名";
    _userText.layer.masksToBounds = YES;
    _userText.layer.cornerRadius = 5.0;
    _userText.layer.borderWidth = 1.0f;
    _userText.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    
    _pwdText = [[UITextField alloc] initWithFrame:CGRectMake(_userText.x, _userText.bottom + 10.0, _userText.width, _userText.height)];
    _pwdText.placeholder = @"密码";
    _pwdText.layer.masksToBounds = YES;
    _pwdText.layer.cornerRadius = 5.0;
    _pwdText.layer.borderWidth = 1.0f;
    _pwdText.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(_pwdText.x, _pwdText.bottom + 20.0, _pwdText.width, _pwdText.height)];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 5.0;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    [loginBtn addTarget:self action:@selector(actionToLogin) forControlEvents:UIControlEventTouchUpInside];
    
    _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 40.0)];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(actionToRegister) forControlEvents:UIControlEventTouchUpInside];
    [_registerButton sizeToFit];
    [_registerButton setY:kScreenHeight - _registerButton.height - 10.0];
    [_registerButton setRight:loginBtn.right];
    
    _userText.text = @"admin";
    _pwdText.text = @"admin";
    
    [self.view addSubview:_userText];
    [self.view addSubview:_pwdText];
    [self.view addSubview:loginBtn];
    [self.view addSubview:_registerButton];
}

- (void) actionToRegister{

    _registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:_registerVC animated:YES];
    
}

- (void) actionToLogin{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_userText.text forKey:UserNameKey];
    [userDefaults setObject:_pwdText.text forKey:PasswordKey];
    [userDefaults setObject:XMPP_DOMAIN forKey:HostnameKey];
    
    [[XMPPTool sharedXMPPTool] connectionWithFailed:^(NSString *errorMessage) {
        NSLog(@"连接失败!");
    }];
}

//- (void) notificationToLogin:(NSNotification *) notification{
//
//    id result = notification.object;
//    if(result){
//        FriendsViewController *friendsVC = [[FriendsViewController alloc] init];
//        [self.navigationController pushViewController:friendsVC animated:YES];
//    }
//}

#pragma mark - system action

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
