//
//  CommentView.m
//  ChatDemo
//
//  Created by acumen on 16/8/2.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "CommentView.h"
#import "UserBean.h"
#import "MLLinkLabel.h"

@interface CommentView()<MLLinkLabelDelegate>

@end

@implementation CommentView{

    UIImageView *_likeViewBg;
    MLLinkLabel *_likeLabel;
    CGFloat _likeHeight;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup{
    
    _likeViewBg = [[UIImageView alloc] init];
    _likeLabel = [[MLLinkLabel alloc] init];
    
    [self addSubview:_likeViewBg];
    [self addSubview:_likeLabel];
    [self bringSubviewToFront:_likeLabel];
    
    [_likeViewBg setImage:[[[UIImage imageNamed:@"LikeCmtBg"]stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_likeViewBg setTintColor:COLOR_RGBA(240.0, 240.0, 240.0, 1.0)];
    [_likeViewBg setBackgroundColor:[UIColor clearColor]];
    
    [_likeViewBg setFrame:CGRectMake(0, 0, self.width, self.height)];
    [_likeLabel setFrame:CGRectMake(0, 2, self.width - 10.0, _likeHeight)];
}

- (void) setLikeItems:(NSArray *) likeItems{
    
    NSAttributedString *attibutedString = [self generateAttributedStringWithUserBeans:likeItems];
    
    [_likeLabel setAttributedText:attibutedString];
    [_likeLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_likeLabel setTextColor:[UIColor blueColor]];
    _likeLabel.delegate = self;
    [_likeLabel setNumberOfLines:0];
    [_likeLabel sizeToFit];
    
    _likeHeight = [self sizeWithString:attibutedString.string font:[UIFont systemFontOfSize:13.0] maxSize:CGSizeMake(self.width, CGFLOAT_MAX)].height + 16.0;
    
    if([likeItems count] == 0){
        [_likeLabel setHidden:YES];
        [_likeViewBg setHidden:YES];
        
    }
    else {
        [_likeLabel setHidden:NO];
        [_likeViewBg setHidden:NO];
    }
    
    [self setHeight:_likeHeight - 3];
    [self layoutSubviews];
}

- (void) layoutSubviews{
    
    [_likeViewBg setFrame:CGRectMake(0, 0, self.width, _likeHeight)];
    [_likeLabel setFrame:CGRectMake(7, 2, self.width - 10.0, _likeHeight)];
}

#pragma mark - MLLinkLabelDelegate

-(void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    
    NSLog(@"%@",linkText);
}

#pragma mark - 计算文字高度

- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

#pragma mark - 生成富文本

- (NSAttributedString *) generateAttributedStringWithUserBeans:(NSArray *) userBeans {

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"Like"];
    attachment.bounds = CGRectMake(0, -4, 16, 16);
    
    [attributedString appendAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
    
    BOOL flag = true;
    for (UserBean *userBean in userBeans) {
        NSString *string = @"";
        
        string = flag? [NSString stringWithFormat:@" %@",userBean.userName]:[NSString stringWithFormat:@", %@",userBean.userName];
        NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:string];
        [tmp addAttribute:NSLinkAttributeName value:[NSString stringWithFormat:@"%@",userBean.userId] range:[string rangeOfString:userBean.userName]];
        
        [attributedString appendAttributedString:tmp];
        
        flag = false;
    }
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:[attributedString.string rangeOfString:tmp.string]];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:[attributedString.string rangeOfString:tmp.string]];
    
    return attributedString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
