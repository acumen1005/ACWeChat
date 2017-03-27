//
//  MenuSliderView.m
//  ChatDemo
//
//  Created by acumen on 16/8/1.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "MenuSliderView.h"

#define SLIDER_WIDTH 140.0

@implementation MenuSliderView{
    
    UIButton *_likeButton;
    UIButton *_commentButton;
    BOOL _show;
    BOOL _likeClicked;
    BOOL _commentClicked;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup {
    _show = NO;
    _likeClicked = NO;
    _commentClicked = NO;
    [self setBackgroundColor:COLOR_RGBA(76, 81, 84, 1.0)];
    
    _likeButton = [[UIButton alloc] init];
    _commentButton = [[UIButton alloc] init];
    UILabel *line = [[UILabel alloc] init];
    
    [self addSubview:_likeButton];
    [self addSubview:_commentButton];
    [self addSubview:line];
    
    [_likeButton setAttributedTitle:[self generateAttributedStringWithImage:@"AlbumLike" Title:@"点赞"] forState:UIControlStateNormal];
    [_likeButton addTarget:self action:@selector(onClickToGiveLike:) forControlEvents:UIControlEventTouchUpInside];
    [_commentButton setAttributedTitle:[self generateAttributedStringWithImage:@"AlbumComment" Title:@"评论"] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(onClickToComment:) forControlEvents:UIControlEventTouchUpInside];
    [line setBackgroundColor:[UIColor whiteColor]];
    
    [_likeButton setFrame:CGRectMake(0, 0, self.width/2.0, self.height)];
    [_commentButton setFrame:CGRectMake(self.width/2.0, 0, self.width/2.0, self.height)];
    [line setFrame:CGRectMake(self.width/2.0, 5.0, 0.5, self.height - 10.0)];
}

#pragma mark - 生成富文本

- (NSAttributedString *) generateAttributedStringWithImage:(NSString *) imageName
                                                     Title:(NSString *) title{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(0, -4, 16, 16);
    
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    
    NSMutableAttributedString *textAttributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString appendAttributedString:textAttributedString];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[attributedString.string rangeOfString:textAttributedString.string]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:[attributedString.string rangeOfString:textAttributedString.string]];
    
    return attributedString;
}

#pragma mark - 按钮方法

- (void) onClickToGiveLike:(UIButton *) button {

    _likeClicked = !_likeClicked;
    
    if(!_likeClicked){
        [button setAttributedTitle:[self generateAttributedStringWithImage:@"AlbumLike" Title:@"点赞"] forState:UIControlStateNormal];
    }
    else {
        [button setAttributedTitle:[self generateAttributedStringWithImage:@"AlbumLike" Title:@"取消"] forState:UIControlStateNormal];
    }
    
    if(self.onClickToGiveLikeBlock){
        self.onClickToGiveLikeBlock(_likeClicked);
    }
}

- (void)onClickToComment:(UIButton *)button {
    
    if(self.onClickToCommentBlock){
        self.onClickToCommentBlock();
    }
}

#pragma mark - getter

- (BOOL)show {
    return _show;
}

#pragma mark - setter

- (void)setShow:(BOOL)show {
    _show = show;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
