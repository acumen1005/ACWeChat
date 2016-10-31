//
//  LL_HeaderView.m
//  ChatDemo
//
//  Created by acumen on 16/10/31.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "LL_HeaderView.h"

@interface LL_HeaderView()

@property (strong,nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) UIView *bgAvatarView;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UIImageView *imageView;

@end

@implementation LL_HeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        [self configSubViews];
        
    }
    return self;
}


#pragma mark - config

- (void) configSubViews {
    
    [self addSubview:self.avatarImageView];
    [self addSubview:self.bgAvatarView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.imageView];
    [self sendSubviewToBack:self.imageView];
    [self bringSubviewToFront:self.avatarImageView];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self.bgAvatarView setBackgroundColor:[UIColor whiteColor]];
    [[self.bgAvatarView layer] setBorderWidth:0.5];
    [[self.bgAvatarView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.avatarImageView setImage:[UIImage imageNamed:@"2"]];
    
    [self.nameLabel setText:@"xxxx"];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setShadowColor:[UIColor grayColor]];
    [self.nameLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.nameLabel sizeToFit];
    
    [self.imageView setImage:[UIImage imageNamed:@"bottleBkg"]];
}

#pragma mark - layout

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat space = 3.0;
    CGFloat avatarSize = kScreenWidth/4.5;
    
    [self.imageView setFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.8)];
    [self.bgAvatarView setFrame:CGRectMake(kScreenWidth - avatarSize * 0.15 - avatarSize, self.imageView.bottom - avatarSize * 0.7, avatarSize, avatarSize)];
    [self.avatarImageView setFrame:CGRectMake(self.bgAvatarView.x + space,self.bgAvatarView.y + space, avatarSize - space * 2, avatarSize - space * 2)];
    
    [self.nameLabel setRight:self.bgAvatarView.x - 10.0];
    [self.nameLabel setBottom:self.imageView.bottom - 10.0];
}

#pragma mark - setter 

- (void) setUserName:(NSString *) userName avatar:(NSString *) avatar backgroudImage:(NSString *) backgroudImage {
    
    [self.avatarImageView setImage:[UIImage imageNamed:avatar]];
    
    [self.nameLabel setText:userName];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setShadowColor:[UIColor grayColor]];
    [self.nameLabel setShadowOffset:CGSizeMake(1.5, 1.5)];
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.nameLabel sizeToFit];
    
    [self.imageView setImage:[UIImage imageNamed:backgroudImage]];
}

#pragma mark - getter

- (UILabel *) nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];;
    }
    return _nameLabel;
}

- (UIView *) bgAvatarView {
    if(!_bgAvatarView) {
        _bgAvatarView = [[UIView alloc] init];
    }
    return  _bgAvatarView;
}

- (UIImageView *) avatarImageView {
    if(!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}

- (UIImageView *) imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - setter

@end
