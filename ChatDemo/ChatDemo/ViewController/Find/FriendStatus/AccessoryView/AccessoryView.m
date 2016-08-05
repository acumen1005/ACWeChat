//
//  AccessoryView.m
//  ChatDemo
//
//  Created by acumen on 16/8/5.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "AccessoryView.h"

#define TEXTVIEW_HEIGHT_MAX 63.0
#define BUTTON_WIDTH (BUTTON_HEIGHT - 10)

static CGFloat originHeight;

@interface AccessoryView()<UITextViewDelegate>

@property (strong,nonatomic) UIButton *emojiButton;
@property (strong,nonatomic) UILabel *line;

@end

@implementation AccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void) setup{

    //4.3文字高度和输入框高度的误差值
    originHeight = BUTTON_HEIGHT;
    
    [self addSubview:self.line];
    [self addSubview:self.commentTextView];
    [self addSubview:self.emojiButton];
    
    [self.line setBackgroundColor:[UIColor lightGrayColor]];
    [self.line setFrame:CGRectMake(0, 0.5, kScreenWidth, 0.5)];
    [self.line setAlpha:0.4];
    
    [self.emojiButton setBackgroundColor:[UIColor blueColor]];
    
    [self.commentTextView setLeft:10];
    [self.commentTextView setTop:5.0];
    [self.commentTextView setHeight:BUTTON_WIDTH];
    [self.commentTextView setWidth:kScreenWidth - 10 * 3 - BUTTON_WIDTH];
    
    [self.emojiButton setWidth:BUTTON_WIDTH];
    [self.emojiButton setHeight:BUTTON_WIDTH];
    [self.emojiButton setLeft:self.commentTextView.right + 10];
    [self.emojiButton setTop:self.commentTextView.top];
    
    [self layoutSubviews];
}

- (void) layoutSubviews {
    
    [self.line setFrame:CGRectMake(0, 0.5, kScreenWidth, 0.5)];
    
    [self.commentTextView setLeft:10];
    [self.commentTextView setTop:5.0];
    [self.commentTextView setHeight:self.height - 5 * 2];
    [self.commentTextView setWidth:kScreenWidth - 10 * 3 - BUTTON_WIDTH];
    
    [self.emojiButton setWidth:BUTTON_WIDTH];
    [self.emojiButton setHeight:BUTTON_WIDTH];
    [self.emojiButton setLeft:self.commentTextView.right + 10];
    [self.emojiButton setTop:self.commentTextView.top];
}


#pragma mark - getter

- (UILabel *) line {
    if(!_line) {
        _line = [[UILabel alloc] init];
    }
    return  _line;
}

- (UIButton *) emojiButton {
    if(!_emojiButton) {
        _emojiButton = [[UIButton alloc] init];
    }
    return _emojiButton;
}

- (GCPlaceholderTextView *) commentTextView {
    if(!_commentTextView){
        _commentTextView = [[GCPlaceholderTextView alloc] init];
//        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5.0, 10)];
        _commentTextView.placeholder = @"评论";
        [[_commentTextView layer] setBorderColor:[COLOR_RGBA(220, 220, 220, 1.0) CGColor]];
        [[_commentTextView layer] setBorderWidth:0.5];
        [_commentTextView setBackgroundColor:[UIColor whiteColor]];
        [[_commentTextView layer] setMasksToBounds:YES];
        [[_commentTextView layer] setCornerRadius:5.0];
        [_commentTextView setFont:[UIFont systemFontOfSize:13.0]];
        _commentTextView.delegate = self;
        _commentTextView.returnKeyType = UIReturnKeySend;
    }
    return _commentTextView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{
    
    CGSize deSize = [textView sizeThatFits:CGSizeMake(textView.width,CGFLOAT_MAX)];
    
    [textView setHeight:MIN(TEXTVIEW_HEIGHT_MAX,deSize.height) - 4.3];
    [self setHeight:textView.height + 10];
    
    if((self.height - originHeight) >= 1.0){
        [self setY:self.y - (self.height - originHeight)];
        originHeight = self.height;
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        [self layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //判断输入的字是否是回车，即按下return 在这里做你响应return键的代码
    if ([text isEqualToString:@"\n"]){
        
        if([textView.text isEqualToString:@""]){
            [SVProgressHUD showInfoWithStatus:@"评论为空"];
            return NO;
        }
        
        if(self.returnTextViewContentBlock){
            self.returnTextViewContentBlock(textView.text,self.indexPath);
        }
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
