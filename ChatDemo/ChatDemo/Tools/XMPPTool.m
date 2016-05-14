//
//  XMPPTool.m
//  ChatDemo
//
//  Created by acumen on 16/4/30.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "XMPPTool.h"

// 用户偏好的键值
// 用户名
NSString *const UserNameKey = @"UserNameKey";
// 密码
NSString *const PasswordKey = @"PasswordKey";
// 主机名
NSString *const HostnameKey = @"HostnameKey";

// 通知字符串定义
NSString *const ResultNotification = @"ResultNotification";

@interface XMPPTool()<XMPPStreamDelegate,XMPPRosterDelegate>

/** 存储失败的回调 */
@property(nonatomic,strong) void (^failed) (NSString * errorMessage);
// 重新连接模块
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

@end

@implementation XMPPTool

#pragma mark - lazy load

- (XMPPStream *)xmppStream
{
    if (_xmppStream == nil) {
        _xmppStream = [[XMPPStream alloc]init];
        
        // 实例化
        _xmppReconnect = [[XMPPReconnect alloc]init];
        _xmppRosterCoreDataStorage = [XMPPRosterCoreDataStorage sharedInstance];
        _xmppRoster = [[XMPPRoster alloc]initWithRosterStorage:_xmppRosterCoreDataStorage dispatchQueue:dispatch_get_global_queue(0, 0)];
        
        // 消息模块(如果支持多个用户，使用单例，所有的聊天记录会保存在一个数据库中)
        _xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
        _xmppMessageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_xmppMessageArchivingCoreDataStorage];
        
        //room
        _xmppRoomCoreDataStorage = [XMPPRoomCoreDataStorage sharedInstance];
        
        // 取消接收自动订阅功能，需要确认才能够添加好友！
        _xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = NO;
        
        // 激活
        [_xmppReconnect activate:_xmppStream];
        [_xmppRoster activate:_xmppStream];
        [_xmppMessageArchiving activate:_xmppStream];
        
        // 添加代理
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
        [_xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _xmppStream;
}

#pragma mark - 单例模式
+ (instancetype)sharedXMPPTool {
    static XMPPTool *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 连接方法
/** 断开连接 */
- (void)disconnect
{
    // 通知服务器，用户下线
    [self goOffline];
    
    [self.xmppStream disconnect];
}

/** 连接方法有失败block回调 */
- (BOOL)connectionWithFailed:(void (^)(NSString *errorMessage))failed
{
    // 需要指定myJID & hostName
    NSString *hostName = [[NSUserDefaults standardUserDefaults] stringForKey:HostnameKey];
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:UserNameKey];
    
    // 判断hostName & userName 是否有内容
    if (hostName.length == 0 || username.length == 0) {
        // 用户偏好中没有记录
        return NO;
    }
    
    // 保存块代码
    self.failed = failed;
    
    // 设置xmppStream的连接信息
    self.xmppStream.hostName = hostName;
    username = [username stringByAppendingFormat:@"@%@", hostName];
    self.xmppStream.myJID = [XMPPJID jidWithString:username];
    
    // 连接到服务器，如果连接已经存在，则不做任何事情
    [self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:NULL];
    
    return YES;
}

#pragma mark - 用户的上线和下线
- (void)goOnline {
    XMPPPresence *p = [XMPPPresence presence];
    
    [self.xmppStream sendElement:p];
}

- (void)goOffline {
    XMPPPresence *p = [XMPPPresence presenceWithType:@"unavailable"];
    
    [self.xmppStream sendElement:p];
}

- (void)logout {
    // 所有用户信息是保存在用户偏好，注销应该删除用户偏好记录
    [self clearUserDefaults];
    
    // 下线，并且断开连接
    [self disconnect];
    
    // 在主线程利用通知发送广播
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ResultNotification object:@(NO)];
    });
}

#pragma mark - xmpp流代理方法
/** 连接成功时调用 */
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接成功");
    
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:PasswordKey];
    
    if (self.isRegisterUser) {
        // 将用户密码发送给服务器，进行用户注册
        [self.xmppStream registerWithPassword:password error:NULL];
        // 将注册标记复位
        self.isRegisterUser = NO;
    } else {
        // 将用户密码发送给服务器，进行用户登录
        NSLog(@"%@",password);
        [self.xmppStream authenticateWithPassword:password error:NULL];
    }
}

/** 断开连接时调用 */
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    NSLog(@"断开连接");
    
    // 在主线程更新UI(用户自己断开的不算)
    if (self.failed && error) {
        dispatch_async(dispatch_get_main_queue(), ^ {self.failed(@"无法连接到服务器");});
    }
}

/** 授权成功时调用 */
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"授权成功");
    
    // 通知服务器用户上线
    [self goOnline];
    
    // 在主线程利用通知发送广播
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ResultNotification object:@(YES)];
    });
}

/** 授权失败时调用 */
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"授权失败");
    
    // 断开与服务器的连接
    [self disconnect];
    // 清理用户偏好
    [self clearUserDefaults];
    // 在主线程更新UI
    if (self.failed) {
        dispatch_async(dispatch_get_main_queue(), ^ {self.failed(@"用户名或者密码错误！");});
    }
    // 在主线程利用通知发送广播
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ResultNotification object:@(NO)];
    });
}

/** 注册成功时调用 */
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"注册成功");
    
    [self logout];
    [self clearUserDefaults];
    //    // 让用户上线
    //    [self goOnline];
    
    // 发送通知，切换控制器
    dispatch_async(dispatch_get_main_queue(), ^{
    });
    
    dispatch_async(dispatch_get_main_queue(), ^ {self.failed(@"注册成功！～请登录");});
}

/** 注册失败时调用 */
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"注册失败");
    
    if (self.failed) {
        dispatch_async(dispatch_get_main_queue(), ^ {self.failed(@"您申请的账号已经被占用！");});
    }
}

#pragma mark - 清除的方法

/** 清除用户的偏好 */
- (void)clearUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; // $$$$$
    
    [defaults removeObjectForKey:UserNameKey];
    [defaults removeObjectForKey:PasswordKey];
    [defaults removeObjectForKey:HostnameKey];
    
    // 刚存完偏好设置，必须同步一下
    [defaults synchronize];
}

/** 销毁调用 */
- (void)teardownXmppStream
{
    // 删除代理 禁用模块 清理缓存
    [self.xmppStream removeDelegate:self];
    [self.xmppRoster removeDelegate:self];
    
    // 取消激活
    [self.xmppReconnect deactivate];
    [self.xmppRoster deactivate];
    
    _xmppReconnect = nil;
    _xmppStream = nil;
    _xmppRosterCoreDataStorage = nil;
    _xmppRoster = nil;
    
}

- (void)dealloc
{
    [self teardownXmppStream];
}


#pragma mark - XMPP花名册代理
// 接收到订阅请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    // 通过代理同样可以知道好友的请求
    
    NSString *msg = [NSString stringWithFormat:@"%@请求添加为好友，是否确认", presence.from];
    
    // 1. 实例化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    // 2. 添加方法
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // 接受好友请求
        [self.xmppRoster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    }]];
    
    // 3. 展现
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender{
    
    NSLog(@"房间创建成功");
    
    [self sendDefaultRoomConfig];
}

#pragma mark - 永久房间的配置

-(void)sendDefaultRoomConfig
{
    
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value"];
    
    NSXMLElement *fieldowners = [NSXMLElement elementWithName:@"field"];
    NSXMLElement *valueowners = [NSXMLElement elementWithName:@"value"];
    
    [field addAttributeWithName:@"var" stringValue:@"muc#roomconfig_persistentroom"];  // 永久属性
    [fieldowners addAttributeWithName:@"var" stringValue:@"muc#roomconfig_roomowners"];  // 谁创建的房间
    
    [field addAttributeWithName:@"type" stringValue:@"boolean"];
    [fieldowners addAttributeWithName:@"type" stringValue:@"jid-multi"];
    
    [value setStringValue:@"1"];
    [valueowners setStringValue:self.xmppStream.myJID.full]; //创建者的Jid
    
    [x addChild:field];
    [x addChild:fieldowners];
    [field addChild:value];
    [fieldowners addChild:valueowners];
    
    [self.xmppRoom configureRoomUsingOptions:x];
}

#pragma mark - IQ请求

- (void)getExistRoom
{
    NSXMLElement *queryElement= [NSXMLElement elementWithName:@"query" xmlns:@"http://jabber.org/protocol/disco#items"];
    NSXMLElement *iqElement = [NSXMLElement elementWithName:@"iq"];
    [iqElement addAttributeWithName:@"type" stringValue:@"get"];
    [iqElement addAttributeWithName:@"from" stringValue:self.xmppStream.myJID.full];
    [iqElement addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"conference.%@",LOCAL_HOST]];
    [iqElement addAttributeWithName:@"id" stringValue:@"getexistroomid"];
    [iqElement addChild:queryElement];
    [self.xmppStream sendElement:iqElement];
}

- (void)getAllRegisteredUsers {
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:users"];
    
    XMPPIQ *iq = [XMPPIQ iqWithType:@"get" elementID:[self.xmppStream generateUUID]];
    [iq addChild:query];
    
    [self.xmppStream sendElement:iq];
}

#pragma mark - IQ响应

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"http://jabber.org/protocol/disco#items"];
    
    if (queryElement) {
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        NSMutableArray *mArray = [[NSMutableArray alloc] init];
        for (int i=0; i<[itemElements count]; i++) {
            
            NSString *jid=[[[itemElements objectAtIndex:i] attributeForName:@"jid"] stringValue];
            [mArray addObject:jid];
        }
        
        NSLog(@"%@",mArray);
    }
    
    return YES;
}


@end
