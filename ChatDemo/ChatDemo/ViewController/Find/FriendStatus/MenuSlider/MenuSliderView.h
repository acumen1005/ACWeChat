//
//  MenuSliderView.h
//  ChatDemo
//
//  Created by acumen on 16/8/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UpdateTableViewCellBlock)();
typedef void (^OnClickToGiveLikeBlock)(BOOL isClick);
typedef void (^OnClickToCommentBlock)();

@interface MenuSliderView : UIView

- (void)drawMenuSliderView;
- (void)setShow:(BOOL)show;
- (BOOL)show;

@property (copy,nonatomic) UpdateTableViewCellBlock updateTableViewCellBlock;
@property (copy,nonatomic) OnClickToGiveLikeBlock onClickToGiveLikeBlock;
@property (copy,nonatomic) OnClickToCommentBlock onClickToCommentBlock;

@end
