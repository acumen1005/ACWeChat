//
//  FindCell.m
//  ChatDemo
//
//  Created by acumen on 16/7/27.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FindCell.h"

@implementation FindCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void) layoutSubviews{

    [super layoutSubviews];
    
    [self.iconImageView setFrame:CGRectMake(10.0, self.height/2.0, self.iconImageView.width, self.iconImageView.height)];
    [self.titleLabel setFrame:CGRectMake(10.0, self.height/2.0, self.titleLabel.width, self.titleLabel.height)];
}


- (void) setImageWithImageName:(NSString *) image
                         Title:(NSString *) title{
    [self.iconImageView setImage:[UIImage imageNamed:image]];
    
    [self.titleLabel setText:title];
    [self.titleLabel setTextColor:COLOR_RGBA(54, 54, 54, 1.0)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self sizeToFit];
    
    [self layoutSubviews];
}
#pragma mark - getter 

- (UIImageView *) iconImageView {
    
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *) titleLabel{
    
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
