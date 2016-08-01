//
//  MenuSliderView.h
//  ChatDemo
//
//  Created by acumen on 16/8/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^UpdateTableViewCellBlock)();

@interface MenuSliderView : UIView

- (void) drawMenuSliderView;
- (void) setShow:(BOOL) show;
- (BOOL) show;

@property (copy,nonatomic) UpdateTableViewCellBlock updateTableViewCellBlock;

@end
