//
//  ACBrowseCell.m
//  Tester
//
//  Created by acumen on 16/6/17.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "ACBrowseCell.h"
#import "UIViewExt.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ACBrowseCell()

@property (strong,nonatomic) UILabel *numberLabel;

@end

@implementation ACBrowseCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
       
        _numberLabel = [[UILabel alloc] init];
        self.image = [[UIImageView alloc] init];
        
        [self addSubview:self.image];
        [self addSubview:_numberLabel];
    }
    return self;
}

#pragma mark - 标号设置

- (void)setNumberLabelWithNumber:(NSInteger) number {

    [self.numberLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)number,(long)_sum]];
    [self.numberLabel setTextColor:[UIColor whiteColor]];
    [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
    [self.numberLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [self.numberLabel setFont:[UIFont boldSystemFontOfSize:self.font]];
    [self.numberLabel sizeToFit];
    
    [self.numberLabel setWidth:self.numberLabel.width + 20];
    [self.numberLabel setHeight:self.numberLabel.height + 10];
    [self.numberLabel setTop:30.0];
    [self.numberLabel setCenterX:kScreenWidth/2.0];
    [[self.numberLabel layer] setMasksToBounds:YES];
    [[self.numberLabel layer] setCornerRadius:self.numberLabel.height/2.0];
}


#pragma mark - 小图设置

- (void)generateSmallImage:(UIImageView *) imageView{
    
    [self.image setImage:imageView.image];
    
    float width = kScreenWidth - 10.0;
    float height = (width / self.image.image.size.width) * self.image.image.size.height;
    
    [self.image setSize:CGSizeMake(width, height)];
    [self.image setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
}

#pragma mark - 变大图

- (void)enlargeImageSize {

    [UIView animateWithDuration:0.3 animations:^{
        float width = kScreenWidth - 10.0;
        float height = (width / self.image.image.size.width) * self.image.image.size.height;
        
        [self.image setSize:CGSizeMake(width, height)];
        [self.image setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
        
    } completion:^(BOOL finished) {
        
    }];
}



@end
