//
//  RoomViewController.h
//  ChatDemo
//
//  Created by acumen on 16/4/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPPMessageArchivingCoreDataStorage.h"
#import "SVProgressHUD.h"
#import "RoomViewController.h"
#import "XMPPRoomMemoryStorage.h"
#import "XMPPFramework.h"
#import "XMPPRoom.h"
#import "XMPP.h"

@interface RoomViewController : UIViewController

@property (strong, nonatomic) XMPPStream * xmppStream;
@property (strong, nonatomic) XMPPReconnect *xmppReconnect;
@property (strong, nonatomic) XMPPRoster *xmppRoster;
@property (strong, nonatomic) XMPPMessageArchiving *xmppMessageArchivering;
@property (strong, nonatomic) NSManagedObjectContext *messageManagerContext;
@property (strong, nonatomic) XMPPRoom *xmppRoom;
@property (strong, nonatomic) XMPPMUC *xmppMUC;

@end
