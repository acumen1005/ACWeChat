//
//  FriendsCell.m
//  ChatDemo
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendsCell.h"

@implementation FriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initView];
    }
    return self;
    
}

#pragma mark - init

- (void) initView{
    
    _nameLabel = [[UILabel alloc] init];
    
    
    [self addSubview:_nameLabel];
    
}

- (void) setNameLabel:(NSString *)name{
    
    _nameLabel.frame = CGRectMake(40, 0, kScreenWidth, 40.0);
    _nameLabel.text = name;
    
}

#pragma mark - system action

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
