//
//  MainTabBarController.m
//  ChatDemo
//
//  Created by acumen on 16/5/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "MainTabBarController.h"
#import "FriendsViewController.h"
#import "RoomViewController.h"
#import "MessageViewController.h"

@interface MainTabBarController ()

@property (strong,nonatomic) FriendsViewController *friendsVC;
@property (strong,nonatomic) RoomViewController *roomVC;
@property (strong,nonatomic) MessageViewController *messageVC;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initView];
}


- (FriendsViewController *) friendsVC {
    if(!_friendsVC){
        _friendsVC = [[FriendsViewController alloc] init];
    }
    return _friendsVC;
}

- (RoomViewController *) roomVC {
    if(!_roomVC){
        _roomVC = [[RoomViewController alloc] init];
    }
    return _roomVC;
}

- (MessageViewController *)messageVC{
    if(!_messageVC){
        _messageVC = [[MessageViewController alloc] init];
    }
    return  _messageVC;
}

- (void) initView{

    [self addChildVc:self.messageVC title:@"消息" image:@"tab_recent_nor" selectedImage:@"tab_recent_press" setTag:0];
    [self addChildVc:self.friendsVC title:@"好友列表" image:@"tab_buddy_nor" selectedImage:@"tab_buddy_press" setTag:1];
    [self addChildVc:self.roomVC title:@"群组" image:@"tab_qworld_nor" selectedImage:@"tab_qworld_press" setTag:0];
    
}

#pragma mark - custom function

/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage setTag:(int) tag
{
    
    childVc.title = title;
    childVc.tabBarItem.tag = tag;
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:1.0]} forState:UIControlStateNormal];
//    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]} forState:UIControlStateSelected];
    
    UINavigationController *navigationVc = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:navigationVc];
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
