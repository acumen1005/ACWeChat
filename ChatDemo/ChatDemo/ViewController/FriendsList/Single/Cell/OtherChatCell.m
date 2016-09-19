//
//  OtherChatCell.m
//  yb
//
//  Created by acumen on 16/4/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "OtherChatCell.h"

#define indent 10.0
#define FONTSIZE 14.0
#define AVATARSIZE 40.0

@interface OtherChatCell()


@end

@implementation OtherChatCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0f];
        [self initView];
    }
    return self;
}


#pragma mark - init

- (void) initView{
    
    _avatarView = [[UIImageView alloc] init];
    _bgImage = [[UIImageView alloc] init];
    _contextLabel = [[UILabel alloc] init];
    
    [self addSubview:_bgImage];
    [self addSubview:_avatarView];
    [_bgImage addSubview:_contextLabel];
}

- (void) setNameLabel:(NSString *)name ContextLabel:(NSString *) context{
    
    _avatarView.frame = CGRectMake(kScreenWidth - 15.0 - 30.0, 0, 30.0, 30.0);
    _avatarView.image = [UIImage imageNamed:@"login_avatar_default"];
    
    _bgImage.frame = CGRectMake(_avatarView.right, _avatarView.y, kScreenWidth - 100.0, 50.0);
    _bgImage.image = [UIImage imageNamed:@"chat_send_nor"];
    [_bgImage setRight:_avatarView.x];
    
    _contextLabel.frame = CGRectMake(20, 10.0, _bgImage.width, _bgImage.height);
    _contextLabel.text = context;
    _contextLabel.textAlignment = NSTextAlignmentRight;
    _contextLabel.font = [UIFont systemFontOfSize:16.0];
    [_contextLabel sizeToFit];
    [_contextLabel setCenterY:_bgImage.centerY];
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
