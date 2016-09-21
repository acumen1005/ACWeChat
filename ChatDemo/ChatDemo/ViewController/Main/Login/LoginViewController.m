//
//  LoginViewController.m
//  ChatDemo
//
//  Created by acumen on 16/4/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPPMessage+Tools.h"
#import "FriendsViewController.h"
#import "RoomViewController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<XMPPStreamDelegate,XMPPRoomStorage,XMPPRosterDelegate,XMPPRoomDelegate>

@property (strong,nonatomic) UITextField *userText;
@property (strong,nonatomic) UITextField *pwdText;
@property (strong,nonatomic) UIButton *registerButton;
@property (strong,nonatomic) UIButton *loginButton;
@property (strong,nonatomic) UIButton *visitLoginButton;
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
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - getter

- (UIButton *) visitLoginButton {
    if(!_visitLoginButton) {
        _visitLoginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, BUTTON_HEIGHT)];
        [_visitLoginButton setTitle:@"免登陆" forState:UIControlStateNormal];
        [[_visitLoginButton titleLabel] setFont:[UIFont systemFontOfSize:13.0]];
        [[_visitLoginButton titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [_visitLoginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_visitLoginButton sizeToFit];
    }
    return _visitLoginButton;
}

- (RoomViewController *) roomVC{
    if(!_roomVC){
        _roomVC = [[RoomViewController alloc] init];
    }
    return _roomVC;
}

- (UITextField *) userText {
    if(!_userText) {
        _userText = [[UITextField alloc] init];
        _userText.placeholder = @"用户名";
        _userText.layer.masksToBounds = YES;
        _userText.layer.cornerRadius = 5.0;
        _userText.layer.borderWidth = 1.0f;
        _userText.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
        UIView *blankView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 40.0)];
        _userText.leftView = blankView1;
        _userText.leftViewMode = UITextFieldViewModeAlways;
        _userText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return  _userText;
}

- (UITextField *) pwdText {
    if(!_pwdText) {
        _pwdText = [[UITextField alloc] init];
        _pwdText.placeholder = @"密码";
        _pwdText.layer.masksToBounds = YES;
        _pwdText.layer.cornerRadius = 5.0;
        _pwdText.layer.borderWidth = 1.0f;
        _pwdText.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
        UIView *blankView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, 40.0)];
        _pwdText.leftView = blankView2;
        _pwdText.leftViewMode = UITextFieldViewModeAlways;
        _pwdText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _pwdText;
}

- (UIButton *) registerButton {
    if(!_registerButton) {
        _registerButton = [[UIButton alloc] init];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_registerButton sizeToFit];
    }
    return  _registerButton;
}

- (UIButton *) loginButton {
    if(!_loginButton) {
        _loginButton = [[UIButton alloc] init];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 5.0;
        _loginButton.layer.borderWidth = 1.0f;
        _loginButton.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    }
    return _loginButton;
}

#pragma mark - init

- (void) initData{
    
    _rosterArray = [[NSMutableArray alloc] init];
}

- (void) initView{

    [self.view addSubview:self.userText];
    [self.view addSubview:self.pwdText];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.visitLoginButton];
    
    [self.registerButton addTarget:self action:@selector(onClick2Register) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton addTarget:self action:@selector(onClick2Login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.visitLoginButton addTarget:self action:@selector(onClick2Visit2Login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.userText setFrame:CGRectMake(kScreenWidth * 0.15, kScreenHeight * 0.3, kScreenWidth * 0.7, 40.0)];
    
    [self.pwdText setFrame:CGRectMake(self.userText.x, self.userText.bottom + 10.0, self.userText.width, self.userText.height)];
    
    [self.registerButton setFrame:CGRectMake(0, 0, kScreenHeight, 40.0)];
    [self.registerButton setRight:kScreenWidth - 10.0];
    [self.registerButton setY:kScreenHeight - self.registerButton.height - 10.0];
    
    [self.loginButton setFrame:CGRectMake(self.pwdText.x, self.pwdText.bottom + 20.0, self.pwdText.width, self.pwdText.height)];
    
    [self.visitLoginButton setTop:self.loginButton.bottom + 5.0];
    [self.visitLoginButton setCenterX:kScreenWidth/2.0];
    
    self.userText.text = @"admin";
    self.pwdText.text = @"admin";
}

#pragma mark - button方法

- (void) onClick2Visit2Login {

    // 在主线程利用通知发送广播
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ResultNotification object:
                    @{DICT_KEY_LOGIN_TYPE:@(0),
                      DICT_KEY_LOGIN_STATUS:@(YES)}];
    });
}

- (void) onClick2Register{

    _registerVC = [[RegisterViewController alloc] init];
    
    [self.navigationController pushViewController:_registerVC animated:YES];
}

- (void) onClick2Login{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_userText.text forKey:UserNameKey];
    [userDefaults setObject:_pwdText.text forKey:PasswordKey];
    [userDefaults setObject:XMPP_DOMAIN forKey:HostnameKey];
    
    [[XMPPTool sharedXMPPTool] connectionWithFailed:^(NSString *errorMessage) {
        NSLog(@"连接失败!");
    }];
}

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
