//
//  FindCell.m
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FindCell.h"

@implementation FindCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconImageView setFrame:CGRectMake(15.0, self.height/2.0 - self.height/1.6/2.0, self.self.height/1.6, self.height/1.6)];
    [self.titleLabel setFrame:CGRectMake(self.iconImageView.right + 10.0, self.iconImageView.centerY - self.titleLabel.height/2.0, self.titleLabel.width, self.titleLabel.height)];
    [self.rightImageView setFrame:CGRectMake(kScreenWidth - self.height/1.6 - 35.0, self.height/2.0 - self.height/1.6/2.0, self.self.height/1.6, self.height/1.6)];
}


- (void)setImageWithImageName:(NSString *)image
                        title:(NSString *)title {
    [self.iconImageView setImage:[UIImage imageNamed:image]];
    
    [self.titleLabel setText:title];
    [self.titleLabel setTextColor:COLOR_RGBA(0.0, 0.0, 0.0, 1.0)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.titleLabel sizeToFit];
    
    [self layoutSubviews];
}

- (void)setRightImageViewWithImageName:(NSString *)rightImageView {

    [self.rightImageView setHidden:NO];
    [self.rightImageView setImage:[UIImage imageNamed:rightImageView]];
}

- (void)dismissRightImageView {
    [self.rightImageView setHidden:YES];
}

#pragma mark - getter 

- (UIImageView *)iconImageView {
    
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)rightImageView {
    if(!_rightImageView){
        _rightImageView = [[UIImageView alloc] init];
    }
    return _rightImageView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}


@end
