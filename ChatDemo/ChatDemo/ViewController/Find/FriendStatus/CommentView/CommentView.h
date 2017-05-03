//
//  CommentView.h
//  ChatDemo
//
//  Created by acumen on 16/8/2.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnLayoutBlock)();

@protocol CommentViewDelegate <NSObject>

- (void)onClickToLabelPushUserInfo:(NSString *)userName;

@end

@interface CommentView : UIView

@property (weak,nonatomic) id<CommentViewDelegate> delegate;

@property (copy,nonatomic) ReturnLayoutBlock returnLayoutBlock;
@property (strong,nonatomic) NSArray *userBeans;

- (void) setLikeItems:(NSArray *) likeItems CommentItems:(NSArray *) commentItems;

@end
