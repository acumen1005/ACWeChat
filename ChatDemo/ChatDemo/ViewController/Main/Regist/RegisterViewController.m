//
//  RegisterViewController.m
//  ChatDemo
//
//  Created by acumen on 16/5/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (strong,nonatomic) UITextField *userText;
@property (strong,nonatomic) UITextField *pwdText;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

#pragma mark - init

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
    
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(_pwdText.x, _pwdText.bottom + 20.0, _pwdText.width, _pwdText.height)];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = 5.0;
    registerBtn.layer.borderWidth = 1.0f;
    registerBtn.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    [registerBtn addTarget:self action:@selector(actionToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_userText];
    [self.view addSubview:_pwdText];
    [self.view addSubview:registerBtn];
}

- (void) actionToRegister{
    
    // 保存至用户偏好
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_userText.text forKey:UserNameKey];
    [defaults setObject:_pwdText.text forKey:PasswordKey];
    [defaults setObject:XMPP_DOMAIN forKey:HostnameKey];
    
    [defaults synchronize];
    
    // 要向服务器注册用户，首先也需要连接到服务器
    [XMPPTool sharedXMPPTool].isRegisterUser = YES;
    
    [[XMPPTool sharedXMPPTool] connectionWithFailed:^(NSString *errorMessage) {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];

}

#pragma mark - system action

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
