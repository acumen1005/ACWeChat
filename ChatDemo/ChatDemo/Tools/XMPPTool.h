//
//  XMPPTool.h
//  ChatDemo
//
//  Created by acumen on 16/4/30.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"
#import "XMPPFramework.h"

// 用户名
extern NSString *const UserNameKey;
// 密码
extern NSString *const PasswordKey;
// 主机名
extern NSString *const HostnameKey;

// 登录结果通知(成功／失败)
extern NSString *const ResultNotification;

typedef void (^ReturnErrorMessage)(NSString *errorMessage);

@interface XMPPTool : NSObject

// 是否是注册用户的标记
@property (nonatomic, assign) BOOL isRegisterUser;

/** xmpp流 */
@property (strong,nonatomic) XMPPStream *xmppStream;
/** 用户花名册 */
@property(nonatomic,strong) XMPPRoster *xmppRoster;

/** 用户花名册归档 */
@property(nonatomic,strong,readonly) XMPPRosterCoreDataStorage * xmppRosterCoreDataStorage;

/** 消息归档 */
@property (nonatomic, strong, readonly) XMPPMessageArchiving *xmppMessageArchiving;
/** 消息归档存储 */
@property (nonatomic, strong, readonly) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;

@property (nonatomic,strong,readonly) XMPPRoomCoreDataStorage *xmppRoomCoreDataStorage;
@property (nonatomic,strong) XMPPRoom *xmppRoom;

@property (strong,nonatomic) NSMutableArray *xmppRooms;

/** 单例模式*/
+ (instancetype)sharedXMPPTool;

- (BOOL)connectionWithFailed:(ReturnErrorMessage )failed;

- (void)disconnect;

// $$$$$
- (void)logout;

- (void)getExistRoom;

- (void)getAllRegisteredUsers;

@end
