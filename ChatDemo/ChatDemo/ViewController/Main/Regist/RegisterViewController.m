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
@property (strong,nonatomic) UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setHidden:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initView];
}

#pragma mark - getter 

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
    return _userText;
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

- (UIButton *) registerBtn{
    if(!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5.0;
        _registerBtn.layer.borderWidth = 1.0f;
        _registerBtn.layer.borderColor = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    }
    return _registerBtn;
}

#pragma mark - init

- (void) initView{

    [self.view addSubview:self.userText];
    [self.view addSubview:self.pwdText];
    [self.view addSubview:self.registerBtn];
    
    [self.registerBtn addTarget:self action:@selector(actionToRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.userText setFrame:CGRectMake(kScreenWidth * 0.15, kScreenHeight * 0.3, kScreenWidth * 0.7, 40.0)];
    
    [self.pwdText setFrame:CGRectMake(_userText.x, _userText.bottom + 10.0, _userText.width, _userText.height)];
    
    [self.registerBtn setFrame:CGRectMake(_pwdText.x, _pwdText.bottom + 20.0, _pwdText.width, _pwdText.height)];
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

#pragma mark - touch 

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
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
