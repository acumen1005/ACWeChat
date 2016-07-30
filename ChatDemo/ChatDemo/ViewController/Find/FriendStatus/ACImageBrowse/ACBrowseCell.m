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

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
       
        _numberLabel = [[UILabel alloc] init];
        self.image = [[UIImageView alloc] init];
        
        [self addSubview:self.image];
        [self addSubview:_numberLabel];
        
    }
    return self;
}

#pragma mark - 标号设置

- (void) setNumberLabelWithNumber:(NSInteger) number {

    [_numberLabel setText:[NSString stringWithFormat:@"%ld/%ld",(long)number,(long)_sum]];
    [_numberLabel setTextColor:[UIColor whiteColor]];
    [_numberLabel setTextAlignment:NSTextAlignmentCenter];
    [_numberLabel setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [_numberLabel setFont:[UIFont boldSystemFontOfSize:_font]];
    [_numberLabel sizeToFit];
    
    [_numberLabel setWidth:_numberLabel.width + 20];
    [_numberLabel setHeight:_numberLabel.height + 10];
    [_numberLabel setTop:30.0];
    [_numberLabel setCenterX:kScreenWidth/2.0];
    [[_numberLabel layer] setMasksToBounds:YES];
    [[_numberLabel layer] setCornerRadius:_numberLabel.height/2.0];
}


#pragma mark - 小图设置

- (void) generateSmallImage:(UIImageView *) imageView{
    
    [self.image setImage:imageView.image];
    
    float width = kScreenWidth - 10.0;
    float height = (width / self.image.image.size.width) * self.image.image.size.height;
    
    [self.image setSize:CGSizeMake(width, height)];
    [self.image setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
    
//    [self.image setSize:imageView.size];
//    [self.image setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];

//    [self enlargeImageSize];
    
//    [self performSelector:@selector(enlargeImageSize) withObject:nil afterDelay:0.1f];
}

#pragma mark - 变大图

- (void) enlargeImageSize {

    [UIView animateWithDuration:0.3 animations:^{
        
        float width = kScreenWidth - 10.0;
        float height = (width / self.image.image.size.width) * self.image.image.size.height;
        
        [self.image setSize:CGSizeMake(width, height)];
        [self.image setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
        
    } completion:^(BOOL finished) {
        
    }];
}



@end
