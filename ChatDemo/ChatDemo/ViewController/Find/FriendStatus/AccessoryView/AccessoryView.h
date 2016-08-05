//
//  AccessoryView.h
//  ChatDemo
//
//  Created by acumen on 16/8/5.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"

typedef void (^ReturnTextViewContentBlock)(NSString *content, NSIndexPath *indexPath);

@interface AccessoryView : UIView

@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) GCPlaceholderTextView *commentTextView;
@property (copy,nonatomic) ReturnTextViewContentBlock returnTextViewContentBlock;

@end
