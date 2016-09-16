//
//  FriendStatusCell.m
//  ChatDemo
//
//  Created by acumen on 16/7/28.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "FriendStatusCell.h"
#import "ACImageBrowseContainerView.h"
#import "MLLinkLabel.h"
#import "MenuSliderView.h"
#import "CommentView.h"
#import "userBean.h"
#import "CommentBean.h"

#define INDENT 10.0
#define WIDTH kScreenWidth/2.2

NSString *const kOperationButtonClickedNotification = @"kOperationButtonClickedNotification";

@interface FriendStatusCell()<MLLinkLabelDelegate,ACImageBrowseContainerView>

@property (strong,nonatomic) FriendStatusBean *friendStatusBean;

@property (strong,nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) MLLinkLabel *nameLabel;
@property (strong,nonatomic) UILabel *contentLabel;
@property (strong,nonatomic) MLLinkLabel *spreadLabel;
@property (strong,nonatomic) ACImageBrowseContainerView *acImageBrowse;
@property (strong,nonatomic) UILabel *timestampLabel;
@property (strong,nonatomic) UIButton *moreButton;
@property (strong,nonatomic) MenuSliderView *menuSliderView;
@property (strong,nonatomic) CommentView *commentView;

@end

@implementation FriendStatusCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.acImageBrowse];
        [self.contentView addSubview:self.spreadLabel];
        [self.contentView addSubview:self.timestampLabel];
        [self.contentView addSubview:self.moreButton];
        [self.contentView addSubview:self.menuSliderView];
        [self.contentView addSubview:self.commentView];
        [self.contentView bringSubviewToFront:self.menuSliderView];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kOperationButtonClickedNotification object:nil];
    }
    return self;
}

#pragma mark - getter

- (UIImageView *) avatarImageView {
    if(!_avatarImageView){
        _avatarImageView = [[UIImageView alloc] init];
    }
    return _avatarImageView;
}

- (MLLinkLabel *) nameLabel {
    if(!_nameLabel){
        _nameLabel = [[MLLinkLabel alloc] init];
        _nameLabel.delegate = self;
    }
    return _nameLabel;
}

- (UILabel *) contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

- (ACImageBrowseContainerView *) acImageBrowse {
    if(!_acImageBrowse) {
        _acImageBrowse = [[ACImageBrowseContainerView alloc] init];
    }
    return _acImageBrowse;
}

- (MLLinkLabel *) spreadLabel {
    if(!_spreadLabel){
        _spreadLabel = [[MLLinkLabel alloc] init];
        [_spreadLabel setAttributedText:[self getAttributedStringWithName:@"全文" LinkAttributeName:@"button"]];
    }
    return _spreadLabel;
}

- (UILabel *) timestampLabel {
    if(!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
    }
    return _timestampLabel;
}

- (UIButton *) moreButton {
    if(!_moreButton) {
        _moreButton = [[UIButton alloc] init];
    }
    return _moreButton;
}

- (MenuSliderView *) menuSliderView {
    if(!_menuSliderView){
        _menuSliderView = [[MenuSliderView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, BUTTON_HEIGHT * 0.8)];
    }
    return _menuSliderView;
}

- (CommentView *) commentView {
    if(!_commentView) {
        _commentView = [[CommentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 50 - INDENT * 3, 35)];
    }
    return _commentView;
}

#pragma mark - setter

- (void) setFriendStatus:(FriendStatusBean *) friendStatusBean{
    
    _friendStatusBean = friendStatusBean;
    
    [self.avatarImageView setImage:[UIImage imageNamed:friendStatusBean.avatarUrl]];
    
    [self.nameLabel setAttributedText:[self getAttributedStringWithName:friendStatusBean.userName LinkAttributeName:@"name"]];
    [self.nameLabel setTextColor:COLOR_RGBA(0, 0, 0, 1.0)];
    [self.nameLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.nameLabel sizeToFit];
    
    [self.contentLabel setText:friendStatusBean.content];
    [self.contentLabel setTextColor:COLOR_RGBA(0, 0, 0, 1.0)];
    [self.contentLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.contentLabel sizeToFit];
    
    [self.spreadLabel setTextColor:COLOR_RGBA(0, 0, 0, 1.0)];
    [self.spreadLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.spreadLabel sizeToFit];
    
    [self.acImageBrowse setFrame:CGRectMake(0, 0, kScreenWidth - 50 - INDENT * 3, (kScreenWidth - 50 - INDENT * 3 - 10))];
    self.acImageBrowse.myDelegate = self;
    //status_image
    self.acImageBrowse.imageNames = friendStatusBean.statusPics;
    self.acImageBrowse.acWidth = (kScreenWidth - 50 - INDENT * 3 - 20) / 3.0;
    self.acImageBrowse.acHeight = self.acImageBrowse.acWidth;
    self.acImageBrowse.horizontalSpacing = 5.0;
    self.acImageBrowse.verticalSpacing = 5.0;
//    [self.acImageBrowse setBackgroundColor:[UIColor greenColor]];
    
    [self.acImageBrowse generateLocalImages];
//    [self.acImageBrowse drawImagesLayout];
    
    [self.timestampLabel setText:[NSString stringWithFormat:@"%@分钟前",@"1"]];
    [self.timestampLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.timestampLabel setTextColor:COLOR_RGBA(116, 116, 116, 1.0)];
    [self.timestampLabel sizeToFit];
    
    [self.moreButton setBackgroundImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(onClickToShowMoreOperater:) forControlEvents:UIControlEventTouchUpInside];
    
    [[self.menuSliderView layer] setMasksToBounds:YES];
    [[self.menuSliderView layer] setCornerRadius:5.0];
    self.menuSliderView.show = friendStatusBean.isCommentStatus;
    
    __weak typeof(self) weakSelf = self;
    
    self.menuSliderView.onClickToCommentBlock = ^(){
    
        if([weakSelf.delegate respondsToSelector:@selector(onClickToComment:)]){
            [weakSelf.delegate onClickToComment:weakSelf.indexPath];
        }
        
        weakSelf.returnTableViewCellBlock(false,weakSelf.indexPath);
    };
    
    self.menuSliderView.onClickToGiveLikeBlock = ^(BOOL isClick){
        
        if([weakSelf.delegate respondsToSelector:@selector(onClickToGivenLike:IsClicked:)]){
            [weakSelf.delegate onClickToGivenLike:weakSelf.indexPath IsClicked:isClick];
        }
        
        if(weakSelf.returnTableViewCellBlock){
            weakSelf.returnTableViewCellBlock(false,weakSelf.indexPath);
        }
    };
    
//    self.commentView.userBeans =
    
    self.commentView.returnLayoutBlock = ^(){
        
        NSLog(@"11111111");
//        weakSelf.returnTableViewCellBlock(false,weakSelf.indexPath);
    };
    
    [self.commentView setLikeItems:friendStatusBean.likes CommentItems:friendStatusBean.comments];
    
    [self layoutSubviews];
}

#pragma mark - layout

- (void) layoutSubviews {
    
    [super layoutSubviews];
    
    [self.avatarImageView setFrame:CGRectMake(INDENT, INDENT, 50, 50)];
    
    [self.nameLabel setLeft:self.avatarImageView.right + INDENT];
    [self.nameLabel setTop:self.avatarImageView.top];
    
    [self.contentLabel setWidth:kScreenWidth - 50.0 - INDENT * 3];
    [self.contentLabel setNumberOfLines:0];
    [self.contentLabel sizeToFit];
    [self.contentLabel setX:self.nameLabel.left];
    [self.contentLabel setY:self.nameLabel.bottom + 5.0];
    
    __weak typeof(self) weakSelf = self;
    weakSelf.spreadLabel.didClickLinkBlock = ^(MLLink *link,NSString *linkText,MLLinkLabel *label){
        
        NSLog(@"%@",linkText);
        if([linkText isEqualToString:@"全文"]){
            [label setAttributedText:[self getAttributedStringWithName:@"收起" LinkAttributeName:@"收起"]];
            
            [self.contentLabel setWidth:kScreenWidth - 50.0 - INDENT * 3];
            [self.contentLabel setNumberOfLines:0];
            [self.contentLabel sizeToFit];
        }
        else {
            [label setAttributedText:[self getAttributedStringWithName:@"全文" LinkAttributeName:@"全文"]];
            [self.contentLabel setHeight:60.0];
        }
        
        self.returnClickLabelBlock(self.indexPath);
    };
    
    if (self.contentLabel.height >= 51.0) {
        if([self.spreadLabel.text isEqualToString:@"全文"]){
            [self.contentLabel setHeight:51.0];
        }
        [self.spreadLabel setHidden:NO];
        
        [self.spreadLabel setLeft:self.nameLabel.left];
        [self.spreadLabel setTop:self.contentLabel.bottom + 5.0];
        
        [self.acImageBrowse setLeft:self.nameLabel.left];
        [self.acImageBrowse setTop:self.spreadLabel.bottom + 5.0];
    }
    else {
        [self.spreadLabel setHidden:YES];
        
        [self.acImageBrowse setLeft:self.nameLabel.left];
        [self.acImageBrowse setTop:self.contentLabel.bottom + INDENT];
    }
    
    [self.timestampLabel setTop:self.acImageBrowse.bottom + 2.0];
    [self.timestampLabel setLeft:self.acImageBrowse.left];
    
    [self.moreButton setWidth:28];
    [self.moreButton setHeight:26];
    [self.moreButton setRight:self.contentLabel.right];
    [self.moreButton setTop:self.timestampLabel.top - 5.0];
    
    [self.menuSliderView setRight:self.moreButton.left];
    [self.menuSliderView setCenterY:self.moreButton.centerY];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGFloat width = self.menuSliderView.show? WIDTH:0.0;
        [self.menuSliderView setWidth:width];
        [self.menuSliderView setRight:self.moreButton.left];
    }];
    
    [self.commentView setLeft:self.nameLabel.left];
    [self.commentView setRight:self.moreButton.right];
    [self.commentView setTop:self.timestampLabel.bottom + 3.0];
}

#pragma mark - 生成富文本

- (NSAttributedString *) getAttributedStringWithName:(NSString *) name
                                   LinkAttributeName:(NSString *) linkAttributeName{

    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:name];
    
    //添加链接
    [attri setAttributes:@{NSForegroundColorAttributeName :[UIColor blueColor], NSLinkAttributeName : linkAttributeName} range:[attri.string rangeOfString:name]];
    
    return  attri;
}

#pragma mark - 按钮事件

- (void) onClickToShowMoreOperater:(UIButton *) button {

//    [self postOperationButtonClickedNotification];
//    
//    self.menuSliderView.show = !self.menuSliderView.show;
    
    self.returnTableViewCellBlock(true,self.indexPath);
}

#pragma mark - UILabel点击事件

- (void) addMaskViewInImageView:(UIImageView *) image ImageName:(NSString *) imageName{

}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel{
    
}

#pragma mark - caloc height

+ (CGFloat) calocCellHeightWithFriendStatus:(FriendStatusBean *) friendStatusBean {
    
    CGSize size = [FriendStatusCell sizeWithString:friendStatusBean.content font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kScreenWidth - 50.0 - INDENT * 3, CGFLOAT_MAX)];
    
    CGFloat height = friendStatusBean.isOpen == NO? 51:size.height;
    
    if(size.height < 51){
        height += INDENT + 17.0 * 2 + 2.0 + 5 + INDENT;
    }
    else {
        
        height += INDENT * 3 + 17.0 * 3 + 2.0;
    }
    height += (kScreenWidth - 50.0 - INDENT * 3)/3.0 * ([friendStatusBean.statusPics count]/3 + ([friendStatusBean.statusPics count]%3 != 0));
    
    //commentView;
    NSAttributedString *attibutedString = [self generateAttributedStringWithUserBeans:friendStatusBean.likes];
    
    size = [FriendStatusCell sizeWithString:attibutedString.string font:[UIFont systemFontOfSize:13.5] maxSize:CGSizeMake(kScreenWidth - 50.0 - INDENT * 4, CGFLOAT_MAX)];
    height += ([friendStatusBean.likes count] == 0? 0:size.height + 3);
    
    height += INDENT * 2;
    for (CommentBean *tmp in friendStatusBean.comments) {
        
        NSString *string = [NSString stringWithFormat:@"%@回复%@：%@",tmp.fromUserName,tmp.toUserName,tmp.commentContent];
        
        CGFloat tmp = [FriendStatusCell sizeWithString:string font:[UIFont systemFontOfSize:13.5] maxSize:CGSizeMake(kScreenWidth - 50.0 - INDENT * 4, CGFLOAT_MAX)].height;
        height += tmp;
    }
    
    return MAX(height + INDENT, INDENT + 50 + INDENT);
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

+ (NSAttributedString *) generateAttributedStringWithUserBeans:(NSArray *) userBeans {
    
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
        
        [attributedString appendAttributedString:tmp];
        
        flag = false;
    }
    return attributedString;
}

#pragma mark - 通知方法

- (void) receiveOperationButtonClickedNotification:(NSNotification *) notification {
    
    UIButton *btn = [notification object];
    
//    NSLog(@"nameLabel -- %@",self.nameLabel.text);
    //除了点击按钮之外，其他按钮有显示的话，取消显示
    if (btn != self.moreButton && self.menuSliderView.show) {
//        
//        __weak typeof(self) weakSelf = self;
//        self.menuSliderView.updateTableViewCellBlock = ^(){
//            [weakSelf layoutSubviews];
//        };

        self.menuSliderView.show = NO;
    }
    
}

#pragma mark - dismiss菜单

- (void) postOperationButtonClickedNotification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kOperationButtonClickedNotification object:self.moreButton];
}

#pragma mark - touch方法

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (!self.menuSliderView.show) {
        self.returnSelectedCellBlock();
    }
    else {
        self.returnTableViewCellBlock(false,self.indexPath);
    }
}

#pragma mark - 系统方法

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
