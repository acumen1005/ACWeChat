//
//  CommonCell.h
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSInteger, CommonCellStyle){
//    CommonCellDefault       = 0, //默认 又icon ＋ title
//    CommonCellSubTitle      = 1, //加 小标题
//    CommonCellRightView     = 2, //加 右边 文字 或者 图片
//    CommonCellMutilImage    = 3, //加 多张图片
//    CommonCellOnlyTilte     = 4, //只有标题
//};

typedef NS_ENUM(NSInteger, SegmentationLineStyle){
    SegmentationLineNone        = 0, //没有分割线
    SegmentationLineIndent      = 1, //缩紧
    SegmentationLineFill        = 2, //长分割线
};

@interface CommonCell : UITableViewCell

@property (strong, nonatomic) UILabel *topLine;
@property (strong, nonatomic) UILabel *bottomLine;
@property (assign, nonatomic) CGFloat leftSpace;

@property (assign, nonatomic) SegmentationLineStyle topLineStyle;
@property (assign, nonatomic) SegmentationLineStyle bottomLineStyle;

@end
