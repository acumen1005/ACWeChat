//
//  FriendsTableViewController.h
//  ChatDemo
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPP.h"

@interface FriendsViewController : UIViewController

@property (strong,nonatomic) NSMutableArray *rosterArray;
@property (strong, nonatomic) XMPPStream * xmppStream;

@end
