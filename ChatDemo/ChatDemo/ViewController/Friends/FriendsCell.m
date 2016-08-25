//
//  FriendsCell.m
//  ChatDemo
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendsCell.h"

@interface FriendsCell()

@property (strong,nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) UILabel *nameLabel;

@end

@implementation FriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.avatarImageView];
        
    }
    return self;
    
}

#pragma mark - init

- (void) initView{
    
    
}

#pragma mark - setter

- (void) setNameLabelWithString:(NSString *) name
                AvatarImageView:(NSString *) imageName{
    
    [self.avatarImageView setImage:[UIImage imageNamed:imageName]];
    [self.avatarImageView setLeft:15.0];
    
    [self.nameLabel setText:name];
    [self.nameLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.nameLabel sizeToFit];
    [self.nameLabel setCenterY:BUTTON_HEIGHT/2.0 + 5];
    [self.nameLabel setLeft:self.avatarImageView.right + 10];
}

#pragma mark - getter 

- (UIImageView *) avatarImageView {
    if(!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, BUTTON_HEIGHT, BUTTON_HEIGHT)];
    }
    return _avatarImageView;
}

- (UILabel *) nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
    }
    return _nameLabel;
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
