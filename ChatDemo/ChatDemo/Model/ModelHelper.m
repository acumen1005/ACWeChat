//
//  ModelHelper.m
//  ChatDemo
//
//  Created by acumen on 16/7/30.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "ModelHelper.h"
#import "FriendStatusBean.h"
#import "CommentBean.h"

@implementation ModelHelper

+ (UserBean *) getUserBean:(NSString *) userName {
    
    NSArray *avatarArray = @[@"avatar-1", @"avatar-2", @"avatar-3", @"avatar-4", @"avatar-5", @"avatar-6", @"avatar-7", @"avatar-9", @"avatar-9"];
    
    NSArray *namesArray = @[@"acumen",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"sherryWanna"];
    
    int ans = 0;
    
    NSMutableArray *userBeans = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [namesArray count]; i++) {
        UserBean *userBean = [[UserBean alloc] init];
        
        userBean.userName = [namesArray objectAtIndex:i];
        userBean.userId = @(i);
        userBean.bottleBackgroud = i%2 == 0 ? @"bottleBkg":@"bottleNightBkg";
        
        int index = ((int)userBean.userName.length/2)%([avatarArray count]);
        userBean.avatar = [avatarArray objectAtIndex:index];
        
        if([userBean.userName isEqualToString:userName]){
            ans = i;
        }
        
        [userBeans addObject:userBean];
    }
    
    return [userBeans objectAtIndex:ans];
}

+ (NSArray *) getFriendStatusWithCount:(NSInteger) count{

    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    NSArray *avatarArray = @[@"avatar-1", @"avatar-2", @"avatar-3", @"avatar-4", @"avatar-5", @"avatar-6", @"avatar-7", @"avatar-9", @"avatar-9"];
    
    NSArray *namesArray = @[@"acumen",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"sherryWanna"];//bottleNightBkg
    
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];

    
    for (int i = 0; i < count; i++) {
        FriendStatusBean *friendStatusBean = [[FriendStatusBean alloc] init];
        
        int random = arc4random_uniform((int)[namesArray count]);
        friendStatusBean.userName = [namesArray objectAtIndex:random];
        
        random = ((int)friendStatusBean.userName.length/2)%([avatarArray count]);
        friendStatusBean.avatarUrl = [avatarArray objectAtIndex:random];
        
        random = arc4random_uniform((int)[textArray count]);
        friendStatusBean.content = [textArray objectAtIndex:random];
        
        NSMutableArray *pics = [[NSMutableArray alloc] init];
        random = arc4random_uniform(9);
        
        for (int j = 0; j < random; j++) {
            int index = arc4random_uniform((int)[avatarArray count]);
            [pics addObject:[avatarArray objectAtIndex:index]];
        }
        friendStatusBean.statusPics = pics;
        
        random = arc4random_uniform(4);
        friendStatusBean.likes = [[NSMutableArray alloc] init];
        for (int j = 0; j < random; j++) {
            int index = arc4random_uniform((int)[namesArray count]);
            UserBean *userBean = [[UserBean alloc] init];
            userBean.userName = [namesArray objectAtIndex:index];
            if(j == 0) {
                j = j + 1;
            }
            userBean.userId = [NSNumber numberWithInt:j + 1];
            
            [friendStatusBean.likes addObject:userBean];
        }
        
        random = arc4random_uniform(4);
        friendStatusBean.comments = [[NSMutableArray alloc] init];
        for (int j = 0; j < random; j++) {
            CommentBean *tmp = [[CommentBean alloc] init];
            tmp.fromUserName = @"acumen";
            tmp.toUserName = @"sherryWanna";
            tmp.commentContent = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
            [friendStatusBean.comments addObject:tmp];
        }
        
        [results addObject:friendStatusBean];
    }
    
    return results;
}

@end
