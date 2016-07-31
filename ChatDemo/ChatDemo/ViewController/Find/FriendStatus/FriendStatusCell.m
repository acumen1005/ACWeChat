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

#define INDENT 10.0

@interface FriendStatusCell()<MLLinkLabelDelegate,ACImageBrowseContainerView>

@property (strong,nonatomic) UIImageView *avatarImageView;
@property (strong,nonatomic) MLLinkLabel *nameLabel;
@property (strong,nonatomic) UILabel *contentLabel;
@property (strong,nonatomic) MLLinkLabel *spreadLabel;
@property (strong,nonatomic) ACImageBrowseContainerView *acImageBrowse;

@end

@implementation FriendStatusCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubview:self.avatarImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.acImageBrowse];
        [self addSubview:self.spreadLabel];
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

#pragma mark - setter

- (void) setFriendStatus:(FriendStatusBean *) friendStatusBean{
    
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
    
    [self.acImageBrowse generateLocalImages];
    [self.acImageBrowse drawImagesLayout];
    
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
    
    if (self.contentLabel.height > 51.0) {
        if([self.spreadLabel.text isEqualToString:@"全文"]){
            [self.contentLabel setHeight:51.0];
        }
        [self.spreadLabel setHidden:NO];
    }
    else {
        [self.spreadLabel setHidden:YES];
    }
    
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
    
    [self.spreadLabel setLeft:self.nameLabel.left];
    [self.spreadLabel setTop:self.contentLabel.bottom + 5.0];
    
    [self.acImageBrowse setLeft:self.nameLabel.left];
    [self.acImageBrowse setTop:self.spreadLabel.bottom + 5.0];

}

#pragma mark - 

- (NSAttributedString *) getAttributedStringWithName:(NSString *) name
                                   LinkAttributeName:(NSString *) linkAttributeName{

    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:name];
    
    //添加链接
    [attri setAttributes:@{NSForegroundColorAttributeName :[UIColor blueColor], NSLinkAttributeName : linkAttributeName} range:[attri.string rangeOfString:name]];
    
    return  attri;
}

#pragma mark - 

- (void) addMaskViewInImageView:(UIImageView *) image ImageName:(NSString *) imageName{

}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink*)link linkText:(NSString*)linkText linkLabel:(MLLinkLabel*)linkLabel{
    
}

#pragma mark - caloc height

+ (CGFloat) calocCellHeightWithFriendStatus:(FriendStatusBean *) friendStatusBean {
    
    CGSize size = [FriendStatusCell sizeWithString:friendStatusBean.content font:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(kScreenWidth - 50.0 - INDENT * 3, CGFLOAT_MAX)];
    
    CGFloat height = friendStatusBean.isOpen == NO? 51:size.height;
    
    height += INDENT * 3 + 17.0 * 3 + 2.0;
    height += (kScreenWidth - 50.0 - INDENT * 3)/3.0 * ([friendStatusBean.statusPics count]/3 + ([friendStatusBean.statusPics count]%3 != 0));
    
    NSLog(@"%f -----====== ",height);
    
    return MAX(height, INDENT + 50 + INDENT);
}

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
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
