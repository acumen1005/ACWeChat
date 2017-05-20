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
#import "CommentBean.h"

#define CONTENT_TOP 10

@interface CommentView()<MLLinkLabelDelegate>

@end

@implementation CommentView{

    UIImageView *_likeViewBg;
    MLLinkLabel *_likeLabel;
    MLLinkLabel *_preLabel;
    NSMutableArray *_commenLabels;
    NSMutableArray *_commenItems;
    UILabel *_line;
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
    
    _commenLabels = [[NSMutableArray alloc] init];
    
    _line = [[UILabel alloc] init];
    _likeViewBg = [[UIImageView alloc] init];
    _likeLabel = [[MLLinkLabel alloc] init];
    
    [self addSubview:_likeViewBg];
    [self addSubview:_likeLabel];
    [self bringSubviewToFront:_likeLabel];
    [self addSubview:_line];
    
    [_likeViewBg setImage:[[[UIImage imageNamed:@"LikeCmtBg"]stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    [_likeViewBg setTintColor:COLOR_RGBA(240.0, 240.0, 240.0, 1.0)];
    [_likeViewBg setBackgroundColor:[UIColor clearColor]];
    
    [_line setHeight:0.3f];
    [_line setBackgroundColor:[UIColor grayColor]];
    [_line setAlpha:0.4];
    
    [_likeViewBg setFrame:CGRectMake(0, 0, self.width, self.height)];
    [_likeLabel setFrame:CGRectMake(0, CONTENT_TOP, self.width - 10.0, _likeHeight)];
}

- (void) setLikeItems:(NSArray *) likeItems CommentItems:(NSArray *) commentItems{
    
    NSAttributedString *attibutedString = [self generateAttributedStringWithUserBeans:likeItems];
    
    [_likeLabel setAttributedText:attibutedString];
    [_likeLabel setFont:[UIFont systemFontOfSize:13.0]];
    [_likeLabel setTextColor:[UIColor blueColor]];
    _likeLabel.delegate = self;
    [_likeLabel setNumberOfLines:0];
    [_likeLabel sizeToFit];
    
    _likeHeight = [self sizeWithString:attibutedString.string font:[UIFont systemFontOfSize:13.5] maxSize:CGSizeMake(self.width -  10.0, CGFLOAT_MAX)].height + 3.0;
    [_likeLabel setFrame:CGRectMake(7, 5, self.width - 10.0, _likeHeight)];
    
    [_likeViewBg setHidden:YES];
    [_likeLabel setHidden:YES];
    [_line setHidden:YES];
    
    if([likeItems count] == 0 && [commentItems count] == 0){
        [_likeViewBg setHidden:YES];
        [_likeLabel setHidden:YES];
        [_line setHidden:YES];
    }
    else {
        [_likeViewBg setHidden:NO];
        
        if([likeItems count] != 0 && [commentItems count] != 0){
            [_likeLabel setHidden:NO];
            [_line setHidden:NO];
        }
        else {
            //只有likeItems ==0
            if([likeItems count] != 0){
                [_likeLabel setHidden:NO];
            }
            else {
                
            }
        }
    }
    
    if (_commenLabels.count) {
        [_commenLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
    _commenItems = [NSMutableArray arrayWithArray:commentItems];
    
    long originCommentItemCouunt = [_commenLabels count];
    long needToAddCount = commentItems.count > originCommentItemCouunt ? (commentItems.count - originCommentItemCouunt) : 0;
    
    for(int i = 0; i < needToAddCount; i++) {
        MLLinkLabel *tmpLinkLabel = [[MLLinkLabel alloc] init];
        [tmpLinkLabel setLeft:7];
        
        [self addSubview:tmpLinkLabel];
        [_commenLabels addObject:tmpLinkLabel];
    }
    
    _preLabel = nil;
    for (int i = 0; i < [_commenItems count]; i++) {
        
        MLLinkLabel *tmpLinkLabel = [_commenLabels objectAtIndex:i];
        CommentBean *commentBean = [_commenItems objectAtIndex:i];
        
        NSAttributedString *string = [self generateAttributedStringWithCommentBean:commentBean];
        [tmpLinkLabel setAttributedText:string];
        [tmpLinkLabel setFont:[UIFont systemFontOfSize:13.5]];
        [tmpLinkLabel setBackgroundColor:COLOR_RGBA(240.0, 240.0, 240.0, 1.0)];
        [tmpLinkLabel setNumberOfLines:0];
        [tmpLinkLabel sizeToFit];
        float height = [self sizeWithString:string.string font:[UIFont systemFontOfSize:13.5] maxSize:CGSizeMake(self.width -  10.0, CGFLOAT_MAX)].height;
        [tmpLinkLabel setWidth:self.width - 7];
        [tmpLinkLabel setHeight:height];
        tmpLinkLabel.delegate = self;
        
        if(i == 0){
            if (_likeLabel.hidden) {
                [tmpLinkLabel setTop:CONTENT_TOP];
            }
            else {
                [tmpLinkLabel setTop:_likeLabel.bottom + CONTENT_TOP];
            }
        }
        else {
            [tmpLinkLabel setTop:_preLabel.bottom];
        }
        tmpLinkLabel.hidden = NO;
        _preLabel = tmpLinkLabel;
    }
    
    [self layoutSubviews];
}

- (void) layoutSubviews{
    
    [_likeViewBg setFrame:CGRectMake(0, 0, self.width, _likeHeight + CONTENT_TOP + 3.0)];
    [_likeLabel setFrame:CGRectMake(7, CONTENT_TOP, self.width - 10.0, _likeHeight)];
    [self setHeight:_likeHeight + CONTENT_TOP];
    
    [_line setWidth:self.width];
    [_line setTop:_likeLabel.bottom - _line.height + 2.0];
    [_line setLeft:0.0];
    
    if(_preLabel) {
        [_likeViewBg setHeight:_preLabel.bottom + 3.0];
        [self setHeight:_preLabel.bottom + 3.0];
    }
}

#pragma mark - MLLinkLabelDelegate

-(void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel{
    
    NSLog(@"%@",linkText);
    
    if([self.delegate respondsToSelector:@selector(onClickToLabelPushUserInfo:)]) {
        [self.delegate onClickToLabelPushUserInfo:linkText];
    }
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
    
    return attributedString;
}


/*
 *  模版式生成评论 返回一个富文本
 *
 *  @param commentBean comment对象
 *
 **/

- (NSAttributedString *)generateAttributedStringWithCommentBean:(CommentBean *)commentBean {
    NSString *string = [NSString stringWithFormat:@"%@回复%@：%@",commentBean.fromUserName,commentBean.toUserName,commentBean.commentContent];
    
    UIColor *highLightColor = [UIColor blueColor];
    NSAttributedString *myString = [[NSAttributedString alloc] initWithString:string];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:myString];
    
    //添加链接
    [attributedString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : @"name"} range:[string rangeOfString:commentBean.fromUserName]];
    //添加链接
    [attributedString setAttributes:@{NSForegroundColorAttributeName : highLightColor, NSLinkAttributeName : @"replyName"} range:[string rangeOfString:commentBean.toUserName]];
    
    return attributedString;
}

@end
