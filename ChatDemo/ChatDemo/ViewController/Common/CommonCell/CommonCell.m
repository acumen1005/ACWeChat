//
//  CommonCell.m
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "CommonCell.h"

@implementation CommonCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        _topLineStyle = SegmentationLineNone;
        _bottomLineStyle = SegmentationLineIndent;
        _leftSpace = 15.0;
    }
    return self;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self.topLine setY:0];
    [self.bottomLine setY:self.height - self.bottomLine.height];
    [self setBottomLineStyle:_bottomLineStyle];
    [self setTopLineStyle:_topLineStyle];
}

#pragma mark - 

- (void) setTopLineStyle:(SegmentationLineStyle)topLineStyle {

    _topLineStyle = topLineStyle;
    
    if(topLineStyle == SegmentationLineNone){
        [self.topLine setHidden:YES];
    }
    else if(topLineStyle == SegmentationLineIndent){
        [self.topLine setX:_leftSpace];
        [self.topLine setWidth:self.width - _leftSpace];
        [self.topLine setHidden:NO];
    }
    else {
        [self.topLine setX:0.0];
        [self.topLine setWidth:self.width];
        [self.topLine setHidden:NO];
    }
}

- (void) setBottomLineStyle:(SegmentationLineStyle)bottomLineStyle {
    
    _bottomLineStyle = bottomLineStyle;
    
    if(bottomLineStyle == SegmentationLineNone){
        [self.bottomLine setHidden:YES];
    }
    else if(bottomLineStyle == SegmentationLineIndent){
        [self.bottomLine setX:_leftSpace];
        [self.bottomLine setWidth:self.width - _leftSpace];
        [self.bottomLine setHidden:NO];
    }
    else {
        [self.bottomLine setX:0.0];
        [self.bottomLine setWidth:self.width];
        [self.bottomLine setHidden:NO];
    }
}


#pragma mark - getter

- (UILabel *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
        [_topLine setHeight:0.5f];
        [_topLine setBackgroundColor:[UIColor grayColor]];
        [_topLine setAlpha:0.4];
        [self.contentView addSubview:_topLine];
    }
    return _topLine;
}

- (UILabel *) bottomLine
{
    if (_bottomLine == nil) {
        _bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
        [_bottomLine setHeight:0.5f];
        [_bottomLine setBackgroundColor:[UIColor grayColor]];
        [_bottomLine setAlpha:0.4];
        [self.contentView addSubview:_bottomLine];
    }
    return _bottomLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
